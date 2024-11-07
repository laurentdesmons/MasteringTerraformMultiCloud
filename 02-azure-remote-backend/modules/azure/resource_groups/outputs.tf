output "resource_groups" {
  value = {
    for rg_name, rg in azurerm_resource_group.resource_groups : rg_name => rg
  }
}