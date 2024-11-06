variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
}

variable "storage_accounts" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    tier                = string
    replication_type    = string
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