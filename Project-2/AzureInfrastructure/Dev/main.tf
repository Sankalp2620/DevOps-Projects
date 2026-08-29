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
  vm_configs         = var.vm_configs
  admin_username     = var.vm_admin_username
  admin_password     = var.vm_admin_password
}