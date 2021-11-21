locals {
  frontend_port_name             = "agw-fe-http"
  frontend_ip_configuration_name = "agw-fe-ip-settings"
  listener_name                  = "${var.solution}-http-listener"
  request_routing_rule_name      = "${var.solution}-rule"
  frontend_pool_name             = "${var.solution}ui-fe-pool"
  backend_pool_name              = "${var.solution}service-be-pool"
  ui_http_settings_name          = "${var.solution}-ui-http-settings"
  service_http_settings_name     = "${var.solution}-service-http-settings"
  url_path_map_name              = "${var.solution}-url-paths"
}

resource "azurerm_application_gateway" "agw" {
  name                = format(var.name_template, "agw-${var.solution}")
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  zones               = ["1"]
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "agw-ip-settings"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw_ipp.id
  }

  backend_address_pool {
    name  = local.frontend_pool_name
    fqdns = [var.ui_hostname]
  }
  backend_address_pool {
    name  = local.backend_pool_name
    fqdns = [var.service_hostname]
  }

  backend_http_settings {
    name                                = local.ui_http_settings_name
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 20
    pick_host_name_from_backend_address = true
  }

  backend_http_settings {
    name                                = local.service_http_settings_name
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 20
    pick_host_name_from_backend_address = true
    path                                = "/"
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name               = local.request_routing_rule_name
    rule_type          = "PathBasedRouting"
    http_listener_name = local.listener_name
    # backend_address_pool_name  = local.frontend_pool_name
    # backend_http_settings_name = local.backend_http_settings_name
    url_path_map_name = local.url_path_map_name
  }

  url_path_map {
    name                               = local.url_path_map_name
    default_backend_http_settings_name = local.ui_http_settings_name
    default_backend_address_pool_name  = local.frontend_pool_name

    path_rule {
      name                       = "${var.solution}-root"
      paths                      = ["/*"]
      backend_http_settings_name = local.ui_http_settings_name
      backend_address_pool_name  = local.frontend_pool_name
    }

    path_rule {
      paths                      = ["/api/*"]
      backend_http_settings_name = local.service_http_settings_name
      name                       = "${var.solution}-api"
      backend_address_pool_name  = local.backend_pool_name
    }

  }
}


resource "azurerm_public_ip" "agw_ipp" {
  name                = format(var.name_template, "ipp")
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  tags                = var.tags
  sku                 = "Standard" #GWv2 requires Standard but v1 can use "Basic"
}


# Add Gateway IP to Public DNS Zone
resource "azurerm_dns_a_record" "agw_dns_record" {
  name                = "${var.env}-${var.solution}"
  zone_name           = var.zone_name
  resource_group_name = var.zone_name_rg
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.agw_ipp.id
  tags                = var.tags
}
