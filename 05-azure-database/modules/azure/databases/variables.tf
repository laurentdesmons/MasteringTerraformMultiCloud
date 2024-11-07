variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
}

# 
# database servers
#
variable "database_servers" {
  type = map(object({
    name                   = string
    version                = string
    resource_group_name    = string
    location               = string
    administrator_login    = string
    administrator_password = string
    zone                   = string
    storage_mb             = number
    sku_name               = string
  }))
  description = "The database servers."
}

# 
# databases
#
variable "databases" {
  type = map(object({
    server_key = string
    name       = string
    charset    = string
    collation  = string
  }))
  description = "The databases."
}

#
# database firewall rules
#
variable "firewall_rules" {
  type = map(object({
    name             = string
    server_key       = string
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "The map of firewall rules to create for the servers."
}

#
# database scripts
#
variable "database_scripts" {
  type = map(object({
    server_key   = string
    database_key = string
    file_path    = string
  }))
  description = "The database scripts to execute after the database is created."
}