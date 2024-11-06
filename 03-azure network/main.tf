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
    for key, sa in var.storage_accounts : key => {
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

#
# Virtual Networks
#
module "network" {
  source = "./modules/azure/network"
  providers = {
    azurerm = azurerm.main
  }

  virtual_networks = {
    for key, network in var.virtual_networks : key => {
      name                = network.name
      resource_group_name = module.resource_groups.resource_groups[network.resource_group_key].name
      location            = module.resource_groups.resource_groups[network.resource_group_key].location
      address_space       = network.address_space
    }
  }
  subnets = {
    for key, subnet in var.subnets : key => {
      name                = subnet.name
      resource_group_name = module.resource_groups.resource_groups[subnet.resource_group_key].name
      virtual_network_key = subnet.virtual_network_key
      address_prefixes    = subnet.address_prefixes
    }
  }
  tags = var.tags
}
