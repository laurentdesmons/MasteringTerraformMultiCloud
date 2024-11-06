#
# Virtual Networks
#
resource "azurerm_virtual_network" "virtual_networks" {
  for_each            = var.virtual_networks
  name                = each.value.name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = var.tags
}

#
# Subnets
#
resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_networks[each.value.virtual_network_key].name
  address_prefixes     = each.value.address_prefixes
}

