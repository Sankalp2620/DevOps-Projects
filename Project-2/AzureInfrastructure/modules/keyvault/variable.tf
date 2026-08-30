variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for Key Vault"
  type        = string
}

variable "location" {
  description = "Location for Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}
