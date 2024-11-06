variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
}

variable "plans" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    os_type             = string
    sku_name            = string
  }))
  description = "map of app service plans to create"
}

variable "app_services" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
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
