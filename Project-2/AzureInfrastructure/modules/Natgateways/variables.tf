variable "natgateway_name" {
  description = "Name of the NAT gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the NAT gateway will be associated"
  type        = string
}