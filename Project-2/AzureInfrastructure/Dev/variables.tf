variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
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

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "address_space" {
  description = "IP address range for the virtual network"
  type        = string
}

variable "public_subnets" {
  description = "Names and address ranges for public subnets"
  type        = map(string)
}

variable "private_subnets" {
  description = "Names and address ranges for private subnets"
  type        = map(string)
}