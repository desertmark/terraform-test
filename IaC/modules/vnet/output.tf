output "agw_subnet_id" {
  value = azurerm_subnet.agw_subnet.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app_service_subnet.id
}
