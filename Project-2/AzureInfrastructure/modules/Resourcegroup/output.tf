output "resource_group_id" {
  description = "Resource group ID"
  value       = azurerm_resource_group.Rg-myphp_app.id
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.Rg-myphp_app.name
}

output "resource_group_location" {
  description = "Resource group location"
  value       = azurerm_resource_group.Rg-myphp_app.location
}
