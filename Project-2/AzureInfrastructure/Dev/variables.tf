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

variable "vm_admin_username" {
  description = "Admin username for the Linux VMs"
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Admin password for the Linux VMs"
  type        = string
  sensitive   = true
  default     = "Password1234!"
}

variable "vm_configs" {
  description = "Configuration for VM placement and allowed ports"
  type = map(object({
    enabled    = bool
    subnet_key = string
    size       = string
    public_ip  = bool
    allow_ssh  = bool
    allow_http = bool
  }))
}

variable "natgateway_name" {
  description = "Name of the NAT gateway"
  type        = string
}

variable "application_gatway_name" {
  description = "Name of the Application Gateway"
  type        = string
}