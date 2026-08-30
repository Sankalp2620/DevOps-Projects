variable "database_server_name" {
  description = "Name of the Azure MySQL Flexible Server"
  type        = string
}

variable "database_name" {
  description = "Database name to create on the MySQL server"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "administrator_login" {
  description = "MySQL administrator login"
  type        = string
}

variable "administrator_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
}

variable "mysql_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.21"
}

variable "sku_name" {
  description = "MySQL Flexible Server SKU"
  type        = string
  default     = "GP_Standard_D2ds_v4"
}

variable "storage_size_gb" {
  description = "Storage size for the MySQL database in GB"
  type        = number
  default     = 20
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "virtual_network_name" {
  description = "Existing virtual network name"
  type        = string
}

variable "virtual_network_id" {
  description = "Existing VNet resource ID"
  type        = string
}

variable "mysql_subnet_name" {
  description = "Name of delegated MySQL subnet"
  type        = string
  default     = "mysql-subnet"
}

variable "mysql_subnet_prefix" {
  description = "CIDR for the delegated MySQL subnet"
  type        = string
  default     = "10.0.5.0/24"
}

variable "private_dns_zone_name" {
  description = "Private DNS zone for MySQL flexible server"
  type        = string
  default     = "privatelink.mysql.database.azure.com"
}
