resource "azurerm_role_assignment" "role_assignment" {
  for_each = var.principal_ids

  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = each.value
}
