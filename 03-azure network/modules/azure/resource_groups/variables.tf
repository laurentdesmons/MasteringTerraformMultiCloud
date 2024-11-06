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