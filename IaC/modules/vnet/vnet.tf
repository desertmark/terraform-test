resource "azurerm_virtual_network" "vnet" {
  name                = format(var.name_template, "vnet-${var.solution}")
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags = var.tags
}

resource "azurerm_subnet" "agw_subnet" {
  name                 = "agw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Web"]
}

# # SecurityGroup
# resource "azurerm_network_security_group" "vnet_agw_sg" {
#   name                = format(var.name_template, "asg-${var.solution}")
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   # App Gateway
#   security_rule {
#     name                       = "agw"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_ranges         = ["80", "443"]
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   tags = var.tags
# }
