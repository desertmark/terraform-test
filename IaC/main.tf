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

