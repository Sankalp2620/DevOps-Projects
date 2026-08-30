variable "scope" {
  description = "Scope where the role assignment is applied"
  type        = string
}

variable "role_definition_name" {
  description = "Name of the Azure role to assign"
  type        = string
}

variable "principal_ids" {
  description = "Map of principal IDs to assign the role to"
  type        = map(string)
}
