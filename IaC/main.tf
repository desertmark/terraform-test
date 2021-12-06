# Azure naming convention resource_type-appName-env-region-instance: i.e: pip-sharepoint-prod-westus-001

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "~>2.85.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  name_template = "%s-${var.env}-${var.solution}-${var.location}-001"
  tags = {
    environment = var.env
    source      = "Terraform"
    solution    = var.solution
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format(local.name_template, "rg")
  location = var.location
  tags     = local.tags
}

module "vnet" {
  source              = "./modules/vnet"
  name_template       = local.name_template
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  solution            = var.solution
  tags                = local.tags
}

module "app_ui" {
  source              = "./modules/app-service"
  name_template       = local.name_template
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_name            = "${var.solution}ui"
  image_name          = var.ui_image_name
  registry_server_url = "https://index.docker.io/"
  tags                = local.tags
  agw_subnet_id       = module.vnet.agw_subnet_id
  tier                = "Basic"
  size                = "B1"
  depends_on = [
    module.vnet
  ]
}

module "app_service" {
  source              = "./modules/app-service"
  name_template       = local.name_template
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_name            = "${var.solution}service"
  image_name          = var.service_image_name
  registry_server_url = "https://index.docker.io/"
  tags                = local.tags
  agw_subnet_id       = module.vnet.agw_subnet_id
  tier                = "Standard"
  size                = "S1"
  subnet_id           = module.vnet.app_subnet_id
  depends_on = [
    module.vnet
  ]
}



module "agw" {
  source              = "./modules/app-gateway"
  name_template       = local.name_template
  location            = var.location
  env                 = var.env
  zone_name           = var.domain
  zone_name_rg        = "Default"
  resource_group_name = azurerm_resource_group.rg.name
  solution            = var.solution
  subnet_id           = module.vnet.agw_subnet_id
  tags                = local.tags
  ui_hostname         = module.app_ui.hostname
  service_hostname    = module.app_service.hostname
  depends_on = [
    module.app_service,
    module.app_ui
  ]
}
