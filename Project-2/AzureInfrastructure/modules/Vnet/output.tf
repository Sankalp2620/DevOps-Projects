output "vnet_id" {
  description = "ID of the created virtual network"
  value       = azurerm_virtual_network.vnet-1-myphpapp.id
}

output "public_subnet_ids" {
  description = "Map of public subnet names to subnet IDs"
  value       = { for subnet_name, subnet in azurerm_subnet.publicSubnet-vnet : subnet_name => subnet.id }
}

output "private_subnet_ids" {
  description = "Map of private subnet names to subnet IDs"
  value       = { for subnet_name, subnet in azurerm_subnet.privateSubnet-vnet : subnet_name => subnet.id }
}