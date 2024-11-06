#
# Storage accounts
#
resource "azurerm_storage_account" "storage_accounts" {
  for_each                 = var.storage_accounts
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.tier
  account_replication_type = each.value.replication_type
  tags                     = var.tags
}

#
# Containers
#
resource "azurerm_storage_container" "containers" {
  for_each             = var.containers
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_accounts[each.value.storage_account_key].name
}