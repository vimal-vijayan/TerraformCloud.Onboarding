resource "azurerm_resource_group" "resource_groups" {
  for_each = local.resource_groups_maps
  name     = format("rg-%s-%s", each.value.name, each.value.environment)
  location = each.value.location
  tags     = zipmap(flatten([for map in each.value.tags : keys(map)]), flatten([for map in each.value.tags : values(map)]))
}
