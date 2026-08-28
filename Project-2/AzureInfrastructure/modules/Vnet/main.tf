resource "azurerm_virtual_network" "vnet-1-myphpapp" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
}


resource "azurerm_subnet" "publicSubnet-vnet" {
  for_each             = var.public_subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-1-myphpapp.name
  address_prefixes     = [each.value]
}

resource "azurerm_subnet" "privateSubnet-vnet" {
  for_each             = var.private_subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-1-myphpapp.name
  address_prefixes     = [each.value]
}
