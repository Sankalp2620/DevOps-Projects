variable "resource_group_name" {
  description = "Resource group name where the VMs will be created"
  type        = string
}

variable "location" {
  description = "Azure region for the VM resources"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  type        = map(string)
}

variable "vm_configs" {
  description = "Virtual machine definitions mapped by VM name"
  type = map(object({
    subnet_key = string
    size       = string
    public_ip  = bool
    allow_ssh  = bool
    allow_http = bool
  }))
}

variable "admin_username" {
  description = "Linux admin username"
  type        = string
}

variable "admin_password" {
  description = "Linux admin password"
  type        = string
  sensitive   = true
}
