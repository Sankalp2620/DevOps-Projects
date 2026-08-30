output "virtual_machines" {
  description = "Map of VM names to VM IDs"
  value = {
    for name, vm in azurerm_linux_virtual_machine.vm : name => vm.id
  }
}

output "virtual_machine_names" {
  description = "Names of all created VMs"
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}

output "network_interfaces" {
  description = "Map of VM names to NIC IDs"
  value = {
    for name, nic in azurerm_network_interface.vm_nic : name => nic.id
  }
}

output "public_ips" {
  description = "Map of VM names to public IP IDs for public VMs"
  value = {
    for name, pip in azurerm_public_ip.vm_public_ip : name => pip.id
  }
}

output "vm_identity_principal_ids" {
  description = "Map of VM names to their managed identity principal IDs"
  value = {
    for name, identity in azurerm_user_assigned_identity.vm_identity : name => identity.principal_id
  }
}

output "public_ip_addresses" {
  description = "Map of VM names to public IP addresses for public VMs"
  value = {
    for name, pip in azurerm_public_ip.vm_public_ip : name => pip.ip_address
  }
}

output "private_ips" {
  description = "Map of VM names to private IP addresses"
  value = {
    for name, nic in azurerm_network_interface.vm_nic : name => nic.ip_configuration[0].private_ip_address
  }
}

output "subnet_ids" {
  description = "Map of VM names to the subnet IDs they are attached to"
  value = {
    for name, nic in azurerm_network_interface.vm_nic : name => nic.ip_configuration[0].subnet_id
  }
}

output "network_security_groups" {
  description = "Map of VM names to NSG IDs"
  value = {
    for name, nsg in azurerm_network_security_group.vm_nsg : name => nsg.id
  }
}
