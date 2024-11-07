#
# public ips
#
resource "azurerm_public_ip" "pips" {
  for_each            = var.linux_vms
  name                = "pip-${each.value.name}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
  tags                = var.tags
}

# 
# network interfaces
#
resource "azurerm_network_interface" "nics" {
  for_each            = var.linux_vms
  name                = "nic-${each.value.name}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pips[each.key].id
  }
  tags = var.tags
}

# 
# linux virtual machines
#
resource "azurerm_linux_virtual_machine" "vms" {
  for_each              = var.linux_vms
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  size                  = each.value.size
  admin_username        = each.value.admin_username
  network_interface_ids = [azurerm_network_interface.nics[each.key].id]
  custom_data           = filebase64(each.value.custom_data)
  identity {
    type = "SystemAssigned"
  }
  admin_ssh_key {
    username   = each.value.admin_username
    public_key = file(each.value.public_key_file)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = each.value.disk_size_gb
  }
  source_image_reference {
    publisher = each.value.image.publisher
    offer     = each.value.image.offer
    sku       = each.value.image.sku
    version   = each.value.image.version
  }
  tags = var.tags
}

# 
#  managed disks
#
resource "azurerm_managed_disk" "disks" {
  for_each             = var.linux_vms
  name                 = "${each.value.name}-datadisk"
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  storage_account_type = each.value.disk.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "disks_attachments" {
  for_each           = var.linux_vms
  managed_disk_id    = azurerm_managed_disk.disks[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.vms[each.key].id
  lun                = "10"
  caching            = "ReadWrite"
}

#
# Bastion Host
#
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "pip-${var.bastion.name}"
  location            = var.bastion.location
  resource_group_name = var.bastion.resource_group_name
  allocation_method   = var.bastion.public_ip.allocation_method
  sku                 = var.bastion.public_ip.sku
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion.name
  location            = var.bastion.location
  resource_group_name = var.bastion.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
  tags = var.tags
}