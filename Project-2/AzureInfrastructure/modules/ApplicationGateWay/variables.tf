variable "application_gatway_name" {
  description = "Application gateway name"
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
  description = "Subnet ID where the Application Gateway is attached"
  type        = string
}

variable "backend_ip_addresses" {
  description = "Private IP address list for backend targets"
  type        = list(string)
}