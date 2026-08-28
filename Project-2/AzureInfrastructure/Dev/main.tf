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
  source = "../modules/Vnet"
  resource_group_name = azurerm_resource_group.Rg-myphp_app.name
  location=azurerm_resource_group.Rg-myphp_app.location
}