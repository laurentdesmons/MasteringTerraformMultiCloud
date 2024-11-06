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
    dotnet_version       = string
    node_version         = string
    app_settings         = map(string)
    connection_strings = map(object({
      name  = string
      type  = string
      value = string
    }))
  }))
  description = "map of app services to create"
}