output "private_endpoint_name" {
  value       = azurerm_private_endpoint.private_endpoint.name
  description = "Private endpoint name of Azure SQL Server."
}
output "private_endpoint_id" {
  value       = azurerm_private_endpoint.private_endpoint.id
  description = "Private endpoint ID of Azure SQL Server."
}
output "private_endpoint_fqdn" {
  value       = azurerm_private_endpoint.private_endpoint.custom_dns_configs[0].fqdn
  description = "Private endpoint FQDN of Azure SQL Server."
}
output "private_endpoint_ip_address" {
  value       = azurerm_private_endpoint.private_endpoint.custom_dns_configs[0].ip_addresses[0]
  description = "Private endpoint IP address of Azure SQL Server."
}