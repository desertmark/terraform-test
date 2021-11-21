resource "azurerm_app_service_plan" "plan" {
  name                = format(var.name_template, "plan-${var.app_name}")
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true
  tags                = var.tags
  sku {
    tier = "Free"
    size = "B1"
  }
}

resource "azurerm_app_service" "app" {
  name                = format(var.name_template, "app-${var.app_name}")
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  tags                = var.tags

  site_config {
    app_command_line          = ""
    linux_fx_version          = "DOCKER|${var.image_name}"
    always_on                 = false
    use_32_bit_worker_process = true

    # Lock down from internet to only be access throw the Application Gateway
    ip_restriction = [{
      action                    = "Allow"
      headers                   = []
      # ip_address                = "0.0.0.0/0"
      ip_address                = null
      name                      = "VirtualNetwork"
      priority                  = 300
      service_tag               = null
      virtual_network_subnet_id = var.agw_subnet_id
    }]
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = var.registry_server_url
  }
}
