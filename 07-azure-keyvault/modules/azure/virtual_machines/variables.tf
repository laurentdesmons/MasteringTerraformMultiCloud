variable "linux_vms" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    subnet_id           = string
    size                = string
    admin_username      = string
    public_key_file     = string
    disk_size_gb        = string
    custom_data         = string
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
}

variable "bastion" {
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    public_ip = object({
      sku               = string
      allocation_method = string
    })
  })
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
}
