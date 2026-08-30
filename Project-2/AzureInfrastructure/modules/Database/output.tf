output "mysql_server_name" {
  description = "Name of the Azure MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.db_server.name
}

output "mysql_server_fqdn" {
  description = "FQDN of the Azure MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.db_server.fqdn
}

output "mysql_database_name" {
  description = "Name of the MySQL database created"
  value       = azurerm_mysql_flexible_database.database.name
}

output "mysql_private_dns_zone_id" {
  description = "Private DNS zone ID"
  value       = azurerm_private_dns_zone.mysql_private_dns_zone.id
}
