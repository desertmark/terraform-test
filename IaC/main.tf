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

module "app_ui" {
  source              = "./modules/app-service"
  name_template       = local.name_template
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_name            = "${var.solution}ui"
  image_name          = var.ui_image_name
  registry_server_url = "https://index.docker.io/"
  tags                = local.tags
}

resource "azurerm_app_service_custom_hostname_binding" "ui_hostname" {
  hostname            = "${var.env}-${var.solution}.${var.domain}"
  app_service_name    = module.app_ui.name
  resource_group_name = azurerm_resource_group.rg.name
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
}

module "vnet" {
  source              = "./modules/vnet"
  name_template       = local.name_template
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  solution            = var.solution
  tags                = local.tags
}

module "agw" {
  source              = "./modules/app-gateway"
  name_template       = local.name_template
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  solution            = var.solution
  subnet_id           = module.vnet.agw_subnet_id
  tags                = local.tags
}
