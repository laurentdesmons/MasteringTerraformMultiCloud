#
# variables
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