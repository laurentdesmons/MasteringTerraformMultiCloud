#
# Resource Groups
#
module "resource_groups" {
  source = "./modules/azure/resource_groups"
  providers = {
    azurerm = azurerm.main
  }
  resource_groups = var.resource_groups
  tags            = var.tags
}

#
# Storage Accounts
#
module "storage_accounts" {
  source = "./modules/azure/storage"
  providers = {
    azurerm = azurerm.main
  }
  storage_accounts = {
    for sa_key, sa in var.storage_accounts : sa_key => {
      name                = sa.name
      resource_group_name = module.resource_groups.resource_groups[sa.resource_group_key].name
      location            = module.resource_groups.resource_groups[sa.resource_group_key].location
      tier                = sa.tier
      replication_type    = sa.replication_type
    }
  }
  containers = var.containers
  tags       = var.tags
}