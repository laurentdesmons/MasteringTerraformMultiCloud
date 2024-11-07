#
# current ad config
#
data "azurerm_client_config" "current" {}

#
# keyvault
#
resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault.name
  location                    = var.keyvault.location
  resource_group_name         = var.keyvault.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = var.keyvault.sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "List",
      "Create",
      "Get",
    ]

    secret_permissions = [
      "List",
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = var.secrets
  name         = each.value.name
  value        = file(each.value.value)
  key_vault_id = azurerm_key_vault.keyvault.id
}