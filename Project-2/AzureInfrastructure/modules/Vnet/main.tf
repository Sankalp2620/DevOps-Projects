resource "azurerm_virtual_network" "vnet-1-myphpapp" {
  name                = "phpapp-vnet"
  location            = azurerm_resource_group.Rg-myphp_app.location
  resource_group_name = azurerm_resource_group.Rg-myphp_app.name
  address_space       = var.Vnet-ipaddress
}


resource "azurerm_subnet" "publicSubnet-vnet" {
  for_each             = var.public_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.Rg-myphp_app.name
  virtual_network_name = azurerm_virtual_network.vnet-1-myphpapp.name
  address_prefixes     = [each.value]
}

resource "azurerm_subnet" "privateSubnet-vnet" {
  for_each             = var.private_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.Rg-myphp_app.name
  virtual_network_name = azurerm_virtual_network.vnet-1-myphpapp.name
  address_prefixes     = [each.value]
}
