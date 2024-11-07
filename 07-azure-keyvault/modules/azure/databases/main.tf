#
# database servers
# 
resource "azurerm_postgresql_flexible_server" "servers" {
  for_each               = var.database_servers
  name                   = each.value.name
  resource_group_name    = each.value.resource_group_name
  location               = each.value.location
  version                = each.value.version
  administrator_login    = each.value.administrator_login
  administrator_password = each.value.administrator_password
  zone                   = each.value.zone
  storage_mb             = each.value.storage_mb
  sku_name               = each.value.sku_name
  timeouts {
    read = "1h"
  }
  tags = var.tags
}

# 
# databases
#
resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each = var.databases
  name     = each.value.name

  server_id = azurerm_postgresql_flexible_server.servers[each.value.server_key].id
  charset   = each.value.charset
  collation = each.value.collation
}

#
# Firewall rules
#
resource "azurerm_postgresql_flexible_server_firewall_rule" "rules" {
  for_each         = var.firewall_rules
  name             = each.value.name
  server_id        = azurerm_postgresql_flexible_server.servers[each.value.server_key].id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

#
# database scripts
#
resource "null_resource" "database_scripts" {
  for_each = var.database_scripts
  provisioner "local-exec" {
    command = "psql -h ${azurerm_postgresql_flexible_server.servers[each.value.server_key].fqdn} -p 5432 -U \"${azurerm_postgresql_flexible_server.servers[each.value.server_key].administrator_login}\" -d ${azurerm_postgresql_flexible_server_database.databases[each.value.database_key].name} -f ${each.value.file_path}"
    environment = {
      PGPASSWORD = "${azurerm_postgresql_flexible_server.servers[each.value.server_key].administrator_password}"
    }
  }
  depends_on = [azurerm_postgresql_flexible_server_firewall_rule.rules]
}
