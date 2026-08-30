resource "azurerm_public_ip" "nat_public_ip" {
  name                = "${var.natgateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "natgateway" {
  name                    = var.natgateway_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "natgateway_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.natgateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "natgateway_subnet_association" {
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.natgateway.id
}


