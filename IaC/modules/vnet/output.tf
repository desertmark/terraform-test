output "agw_subnet_id" {
  value = var.gateway == "azure" ? azurerm_subnet.agw_subnet[0].id : null
}

output "app_subnet_id" {
  value = azurerm_subnet.app_service_subnet.id
}
