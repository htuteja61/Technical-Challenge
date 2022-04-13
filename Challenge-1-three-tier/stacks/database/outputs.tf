output "sql_server_name" {
  value       = azurerm_mssql_server.sql_server.name
  description = "Name of the Azure SQL server."
}
output "sql_server_id" {
  value       = azurerm_mssql_server.sql_server.id
  description = "ID of the Azure SQL server."
}
output "sql_database_name" {
  value       = azurerm_mssql_database.sql_database.name
  description = "Names of the Azure SQL database"
}
output "sql_database_id" {
  value       = azurerm_mssql_database.sql_database.id
  description = "ID of the Azure SQL database."
}
output "connection" {
  value = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name} Database=${azurerm_mssql_database.sql_database.name};User ID=${azurerm_mssql_server.sql_server.administrator_login};Password=${azurerm_mssql_server.sql_server.administrator_login_password};Trusted_Connection=False;Encrypt=True;"
}
