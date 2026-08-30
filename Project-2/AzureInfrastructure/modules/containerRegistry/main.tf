resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                        = "East US"
    global_endpoint_routing_enabled = false
    zone_redundancy_enabled         = false
    tags                            = {}
  }
  georeplications {
    location                        = "North Europe"
    global_endpoint_routing_enabled = false
    zone_redundancy_enabled         = false
    tags                            = {}
  }
}

