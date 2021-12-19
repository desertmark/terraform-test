# Two types of gateways are supported so we create ip_restriction for both of them and we use only the one needed based on the given config.
locals {
  agw_ip_restriction = var.agw_subnet_id != null ? [{
    action                    = "Allow"
    headers                   = []
    ip_address                = null
    name                      = "VirtualNetwork"
    priority                  = 300
    service_tag               = null
    virtual_network_subnet_id = var.agw_subnet_id
  }] : []
  nginx_ip_restrictions = var.nginx_ips != null ? [for ip in var.nginx_ips : {
    action                    = "Allow"
    headers                   = []
    ip_address                = "${ip}/32"
    name                      = "gw-ip-${ip}"
    priority                  = 300
    service_tag               = null
    virtual_network_subnet_id = null
  }] : []
}

resource "azurerm_app_service_plan" "plan" {
  name                = format(var.name_template, "plan-${var.app_name}")
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true
  tags                = var.tags
  sku {
    tier = var.tier
    size = var.size
  }
}

resource "azurerm_app_service" "app" {
  name                = format(var.name_template, "app-${var.app_name}")
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  tags                = var.tags

  logs {
    http_logs {
      file_system {
        retention_in_days = 1
        retention_in_mb   = 25
      }
    }
  }

  site_config {
    app_command_line          = ""
    linux_fx_version          = "DOCKER|${var.image_name}"
    always_on                 = false
    use_32_bit_worker_process = true
    # Lock down from internet to only be access throw the Application Gateway
    ip_restriction = concat(local.agw_ip_restriction, local.nginx_ip_restrictions)
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = var.registry_server_url
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_vnet_integration" {
  # Only create if subnet_id is provided. Requires "Standard" Tier.
  count          = var.subnet_id != null ? 1 : 0
  app_service_id = azurerm_app_service.app.id
  subnet_id      = var.subnet_id
}


resource "azurerm_dns_cname_record" "app_dns_record" {
  count               = var.include_dns_record ? 1 : 0
  name                = var.dns_record_name
  zone_name           = var.zone_name
  resource_group_name = var.zone_name_rg
  ttl                 = 300
  target_resource_id  = azurerm_app_service.app.id
}
