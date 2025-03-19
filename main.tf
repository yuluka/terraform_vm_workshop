provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

resource "azurerm_resource_group" "mi_primera_vm_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "mi_primera_vm_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.mi_primera_vm_rg.location
  resource_group_name = azurerm_resource_group.mi_primera_vm_rg.name
}

resource "azurerm_subnet" "mi_primera_vm_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.mi_primera_vm_rg.name
  virtual_network_name = azurerm_virtual_network.mi_primera_vm_vnet.name
  address_prefixes     = var.subnet_prefix
}

resource "azurerm_public_ip" "mi_primera_vm_public_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.mi_primera_vm_rg.location
  resource_group_name = azurerm_resource_group.mi_primera_vm_rg.name
  allocation_method   = var.public_ip_allocation_method
}

resource "azurerm_network_interface" "mi_primera_vm_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.mi_primera_vm_rg.location
  resource_group_name = azurerm_resource_group.mi_primera_vm_rg.name

  ip_configuration {
    name                          = var.private_ip_name
    subnet_id                     = azurerm_subnet.mi_primera_vm_subnet.id
    private_ip_address_allocation = var.private_ip_allocation_method
    public_ip_address_id          = azurerm_public_ip.mi_primera_vm_public_ip.id
  }
}

resource "azurerm_network_security_group" "mi_primera_vm_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.mi_primera_vm_rg.location
  resource_group_name = azurerm_resource_group.mi_primera_vm_rg.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_network_interface_security_group_association" "mi_primera_vm_nsg_association" {
  network_interface_id      = azurerm_network_interface.mi_primera_vm_nic.id
  network_security_group_id = azurerm_network_security_group.mi_primera_vm_nsg.id
}

resource "azurerm_linux_virtual_machine" "mi_primera_vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.mi_primera_vm_rg.name
  location            = azurerm_resource_group.mi_primera_vm_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.mi_primera_vm_nic.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  disable_password_authentication = false
  provision_vm_agent              = true
}
