module "resource_group" {
  source              = "../modules/Resourcegroup"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
    Project     = "AzureInfrastructure"
  }
}

module "virtual_network" {
  source              = "../modules/Vnet"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
}

module "virtual_machines" {
  source              = "../modules/VirtualMachines"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_ids = merge(
    module.virtual_network.public_subnet_ids,
    module.virtual_network.private_subnet_ids
  )
  vm_configs     = var.vm_configs
  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password
}

module "nat_gateway" {
  source = "../modules/Natgateways"

  natgateway_name     = var.natgateway_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.virtual_network.private_subnet_ids["private-subnet-1"]
}

module "application_gateway" {
  source = "../modules/ApplicationGateWay"
  application_gatway_name = var.application_gatway_name
  resource_group_name      = module.resource_group.resource_group_name
  location                 = module.resource_group.resource_group_location
  subnet_id                = module.virtual_network.public_subnet_ids["public-subnet-2"]
  backend_ip_addresses     = [module.virtual_machines.private_ips["private-app-vm"]]
}

module "database" {
  source = "../modules/Database"
  database_server_name   = var.database_server_name
  database_name          = var.database_name
  resource_group_name    = module.resource_group.resource_group_name
  location               = module.resource_group.resource_group_location
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  virtual_network_name   = module.virtual_network.vnet_id != null ? var.vnet_name : var.vnet_name
  virtual_network_id     = module.virtual_network.vnet_id
  mysql_subnet_name      = var.mysql_subnet
  mysql_subnet_prefix    = var.mysql_subnet_prefix
}

module "container_Registry" {
  source = "../modules/containerRegistry"
  acr_name = var.acr_name
  resource_group_name = module.resource_group.resource_group_name
  location = module.resource_group.resource_group_location
}

module "vm_acr_role_assignment" {
  source = "../modules/RoleAssignments"
  scope = module.container_Registry.acr_id
  role_definition_name = "Contributor"
  principal_ids = module.virtual_machines.vm_identity_principal_ids
}

module "key_vault" {
  source = "../modules/keyvault"
  key_vault_name = var.key_vault_name
  resource_group_name = module.resource_group.resource_group_name
  location = module.resource_group.resource_group_location
  tenant_id = var.tenant_id
}

module "vm_keyvault_role_assignment" {
  source = "../modules/RoleAssignments"
  scope = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_ids = module.virtual_machines.vm_identity_principal_ids
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../Ansible/inventory.ini"

  content = <<-EOT
[web]
public-web-vm ansible_host=${module.virtual_machines.public_ip_addresses["public-web-vm"]} ansible_user=${var.vm_admin_username} ansible_password=${var.vm_admin_password} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT
}



