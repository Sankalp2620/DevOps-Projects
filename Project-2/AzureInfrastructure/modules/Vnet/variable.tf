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

variable "resource_group_name" {
  description = "Name of the resource group for the VNet"
  type        = string
}

variable "location" {
  description = "Azure region for the VNet"
  type        = string
}