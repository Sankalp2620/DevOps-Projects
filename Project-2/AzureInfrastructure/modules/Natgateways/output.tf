output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = azurerm_nat_gateway.natgateway.id
}

output "nat_public_ip_id" {
  description = "ID of the public IP associated with the NAT gateway"
  value       = azurerm_public_ip.nat_public_ip.id
}

output "nat_public_ip_address" {
  description = "Public IP address of the NAT gateway"
  value       = azurerm_public_ip.nat_public_ip.ip_address
}
