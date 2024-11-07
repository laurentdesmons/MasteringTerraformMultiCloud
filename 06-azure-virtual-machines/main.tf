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
# Network
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

#
# App Services
#
module "app_services" {
  source = "./modules/azure/appservices"
  providers = {
    azurerm = azurerm.main
  }
  plans = {
    for key, plan in var.app_service_plans : key => {
      name                = plan.name
      resource_group_name = module.resource_groups.resource_groups[plan.resource_group_key].name
      location            = module.resource_groups.resource_groups[plan.resource_group_key].location
      os_type             = plan.os_type
      sku_name            = plan.sku_name
    }
  }
  app_services = {
    for key, app in var.app_services : key => {
      name                 = app.name
      resource_group_name  = module.resource_groups.resource_groups[app.resource_group_key].name
      location             = module.resource_groups.resource_groups[app.resource_group_key].location
      app_service_plan_key = app.app_service_plan_key
      node_version         = app.node_version
      source_control       = app.source_control
      app_settings         = app.app_settings
      connection_strings   = app.connection_strings
    }
  }
  tags = var.tags
}

#
# Databases
#
module "databases" {
  source = "./modules/azure/databases"
  providers = {
    azurerm = azurerm.main
  }

  database_servers = {
    for key, server in var.database_servers : key => {
      name                   = server.name
      version                = server.version
      resource_group_name    = module.resource_groups.resource_groups[server.resource_group_key].name
      location               = module.resource_groups.resource_groups[server.resource_group_key].location
      administrator_login    = server.administrator_login
      administrator_password = server.administrator_password
      zone                   = server.zone
      storage_mb             = server.storage_mb
      sku_name               = server.sku_name
    }
  }
  databases        = var.databases
  firewall_rules   = var.database_servers_firewall_rules
  database_scripts = var.database_scripts
  tags             = var.tags
}

#
# Virtual Machines
#
module "virtual_machines" {
  source = "./modules/azure/virtual_machines"
  providers = {
    azurerm = azurerm.main
  }

  linux_vms = {
    for key, vm in var.linux_vms : key => {
      name                = vm.name
      resource_group_name = module.resource_groups.resource_groups[vm.resource_group_key].name
      location            = module.resource_groups.resource_groups[vm.resource_group_key].location
      subnet_id           = module.network.subnets[vm.subnet_key].id
      size                = vm.size
      admin_username      = vm.admin_username
      public_key_file     = vm.public_key_file
      disk_size_gb        = vm.disk_size_gb
      custom_data         = vm.custom_data
      image               = vm.image
      disk                = vm.disk
    }
  }

  bastion = {
    name                = var.bastion.name
    resource_group_name = module.resource_groups.resource_groups[var.bastion.resource_group_key].name
    location            = module.resource_groups.resource_groups[var.bastion.resource_group_key].location
    subnet_id           = module.network.subnets[var.bastion.subnet_key].id
    public_ip           = var.bastion.public_ip
  }
  tags = var.tags
}
