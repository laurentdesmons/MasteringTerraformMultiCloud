variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
}

variable "virtual_networks" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
  }))
  description = "map of virtual networks to create"
}

variable "subnets" {
  type = map(object({
    name                = string
    resource_group_name = string
    virtual_network_key = string
    address_prefixes    = list(string)
  }))
  description = "map of subnets to create"
}