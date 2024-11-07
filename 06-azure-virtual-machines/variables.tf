#
# Azure variables
#
variable "subscription_id" {
  type        = string
  description = "The subscription id for the Azure tenant"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
}

variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
  description = "map of resource groups to create"
}

variable "storage_accounts" {
  type = map(object({
    name               = string
    resource_group_key = string
    tier               = string
    replication_type   = string
  }))
  description = "map of storage accounts to create"
}

variable "containers" {
  type = map(object({
    name                = string
    storage_account_key = string
  }))
  description = "map of containers to create"
}

variable "virtual_networks" {
  type = map(object({
    name               = string
    resource_group_key = string
    address_space      = list(string)
  }))
  description = "map of virtual networks to create"
}

variable "subnets" {
  type = map(object({
    name                = string
    resource_group_key  = string
    virtual_network_key = string
    address_prefixes    = list(string)
  }))
  description = "map of subnets to create"
}

variable "app_service_plans" {
  type = map(object({
    name               = string
    resource_group_key = string
    os_type            = string
    sku_name           = string
  }))
  description = "map of app service plans to create"
}

variable "app_services" {
  type = map(object({
    name                 = string
    resource_group_key   = string
    app_service_plan_key = string
    node_version         = string
    source_control = object({
      repo_url = string
      branch   = string
    })
    app_settings = map(string)
    connection_strings = map(object({
      name  = string
      type  = string
      value = string
    }))
  }))
  description = "map of app services to create"
}

variable "database_servers" {
  type = map(object({
    name                   = string
    version                = string
    resource_group_key     = string
    administrator_login    = string
    administrator_password = string
    zone                   = string
    storage_mb             = number
    sku_name               = string
  }))
  description = "The database servers."
}

variable "databases" {
  type = map(object({
    server_key = string
    name       = string
    charset    = string
    collation  = string
  }))
  description = "The databases."
}

variable "database_servers_firewall_rules" {
  type = map(object({
    name             = string
    server_key       = string
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "The map of firewall rules to create for the servers."
}

variable "database_scripts" {
  type = map(object({
    server_key   = string
    database_key = string
    file_path    = string
  }))
  description = "The database scripts to execute after the database is created."
}

variable "linux_vms" {
  type = map(object({
    name               = string
    resource_group_key = string
    subnet_key         = string
    size               = string
    admin_username     = string
    public_key_file    = string
    disk_size_gb       = string
    custom_data        = string
    image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    disk = object({
      storage_account_type = string
      disk_size_gb         = number
    })
  }))
  description = "The Linux Virtual Machines."
}

variable "bastion" {
  type = object({
    name               = string
    resource_group_key = string
    subnet_key         = string
    public_ip = object({
      sku               = string
      allocation_method = string
    })
  })
}