# Azure naming convention resource_type-appName-env-region-instance: i.e: pip-sharepoint-prod-westus-001

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "~>2.31.1"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  name_template = "%s-${var.env}-${var.location}-001"
  tags = {
    environment = var.env
    source      = "Terraform"
    solution    = "todo"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format(local.name_template, "rg-todo")
  location = var.location
  tags     = local.tags
}

module "app_todoui" {
  source              = "./modules/app-service"
  name_template       = local.name_template
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_name            = "todoui"
  image_name          = "desertmark/todoui:latest"
  registry_server_url = "https://index.docker.io/"
  tags                = local.tags
}

resource "azurerm_app_service_custom_hostname_binding" "todoui_hostname" {
  hostname            = "${var.env}-todo.${var.domain}"
  app_service_name    = module.app_todoui.name
  resource_group_name = azurerm_resource_group.rg.name
}

module "app_todoservice" {
  source              = "./modules/app-service"
  name_template       = local.name_template
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_name            = "todoservice"
  image_name          = "desertmark/todoservice:latest"
  registry_server_url = "https://index.docker.io/"
  tags                = local.tags
}