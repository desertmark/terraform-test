locals {
  frontend_port_name             = "agw-fe-http"
  frontend_ip_configuration_name = "agw-fe-ip-settings"
  listener_name                  = "${var.solution}-listener"
  request_routing_rule_name      = "${var.solution}-rule"
  frontend_pool_name             = "${var.solution}ui-fe-pool"
  backend_pool_name              = "${var.solution}service-be-pool"
  backend_http_settings_name     = "${var.solution}-http-settings"
  url_path_map_name              = "${var.solution}-url-paths"
}

resource "azurerm_application_gateway" "agw" {
  name                = format(var.name_template, "agw-${var.solution}")
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  sku {
    name     = "Standard_Small"
    tier     = "Standard"
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
    name = local.frontend_pool_name
  }
  backend_address_pool {
    name = local.backend_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.frontend_pool_name
    backend_http_settings_name = local.backend_http_settings_name
    url_path_map_name          = local.url_path_map_name
  }

  url_path_map {
    name = local.url_path_map_name

    path_rule {
      paths                      = ["/*"]
      backend_http_settings_name = local.backend_http_settings_name
      name                       = "${var.solution}-root"
      backend_address_pool_name  = local.frontend_pool_name
    }

    path_rule {
      paths                      = ["/api/*"]
      backend_http_settings_name = local.backend_http_settings_name
      name                       = "${var.solution}-api"
      backend_address_pool_name  = local.backend_pool_name
    }

  }

  rewrite_rule_set {
    name = "remove-api"
    rewrite_rule {
      name = "${var.solution}service-rw-rule"
      # if url path has /api
      condition {
        variable    = "uri_path"
        ignore_case = true
        pattern     = ".*api/(.*)"
      }
      # Rewrite to replace /api with ""
      url {
        path = "/{var_uri_path_1}"
      }
      rule_sequence = 1
    }
  }
}


resource "azurerm_public_ip" "agw_ipp" {
  name                = format(var.name_template, "ipp-${var.solution}")
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = var.tags
}
