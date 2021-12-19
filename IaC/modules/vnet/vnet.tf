resource "azurerm_virtual_network" "vnet" {
  name                = format(var.name_template, "vnet-${var.solution}")
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "app_service_subnet" {
  name                 = "app-service-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  delegation {
    name = "app-vnet-integration"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "agw_subnet" {
  count                = var.gateway == "azure" ? 1 : 0
  name                 = "agw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Web"]
}

# SecurityGroup
resource "azurerm_network_security_group" "vnet_agw_sg" {
  count               = var.gateway == "azure" ? 1 : 0
  name                = format(var.name_template, "agw-nsg")
  location            = var.location
  resource_group_name = var.resource_group_name

  # App Gateway
  security_rule {
    name                       = "agw"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Port_80"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg-agw" {
  count                     = var.gateway == "azure" ? 1 : 0
  subnet_id                 = azurerm_subnet.agw_subnet[0].id
  network_security_group_id = azurerm_network_security_group.vnet_agw_sg[0].id
}
