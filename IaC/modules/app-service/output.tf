output "name" {
  value = azurerm_app_service.app.name
}

output "hostname" {
  value = azurerm_app_service.app.default_site_hostname
}

output "outbound_ips" {
  value = azurerm_app_service.app.outbound_ip_address_list
}