variable "keyvault" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    sku_name            = string
  })
}

variable "secrets" {
  type = map(object({
    name  = string
    value = string
  }))
  description = "map of secrets to create"
}