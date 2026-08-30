resource "azurerm_subnet" "mysql_private_subnet" {
  name                 = var.mysql_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.mysql_subnet_prefix]

  delegation {
    name = "mysqldelegation"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "mysql_private_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql_vnet_link" {
  name                  = "${var.virtual_network_name}-mysql-link"
  private_dns_zone_id   = azurerm_private_dns_zone.mysql_private_dns_zone.id
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}

resource "azurerm_mysql_flexible_server" "db_server" {
  name                         = var.database_server_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  administrator_login          = var.administrator_login
  administrator_password       = var.administrator_password
  version                      = var.mysql_version
  sku_name                     = var.sku_name
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = false
  delegated_subnet_id          = azurerm_subnet.mysql_private_subnet.id
  private_dns_zone_id          = azurerm_private_dns_zone.mysql_private_dns_zone.id

  storage {
    size_gb = var.storage_size_gb
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql_vnet_link]
}

resource "azurerm_mysql_flexible_database" "database" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}
