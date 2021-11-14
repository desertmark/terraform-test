resource "azurerm_virtual_network" "vnet" {
  name                = format(var.name_template, "vnet-${var.solution}")
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  # dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "agw-subnet"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.vnet_agw_sg.id
  }

  tags = var.tags
}

# SecurityGroup
resource "azurerm_network_security_group" "vnet_agw_sg" {
  name                = format(var.name_template, "asg-${var.solution}")
  location            = var.location
  resource_group_name = var.resource_group_name

  # App Gateway
  security_rule {
    name                       = "agw"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_ranges         = ["80", "443"]
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}
