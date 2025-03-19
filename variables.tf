variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "94101e63-55cd-434a-bf37-69fa8ccffe39"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "mi_primera_vm_rg"
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "mi_primera_vm_vnet"
}

variable "vnet_address_space" {
  description = "Virtual Network Address Space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
  default     = "mi_primera_vm_subnet"
}

variable "subnet_prefix" {
  description = "CIDR block for the subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "public_ip_name" {
  description = "Public IP Name"
  type        = string
  default     = "mi_primera_vm_public_ip"
}

variable "public_ip_allocation_method" {
  description = "Public IP Allocation Method"
  type        = string
  default     = "Static"
}

variable "private_ip_name" {
  description = "Private IP Name"
  type        = string
  default     = "internal"
}

variable "private_ip_allocation_method" {
  description = "Private IP Allocation Method"
  type        = string
  default     = "Dynamic"
}

variable "nic_name" {
  description = "Network Interface Name"
  type        = string
  default     = "mi_primera_vm_nic"
}

variable "nsg_name" {
  description = "Network Security Group Name"
  type        = string
  default     = "mi_primera_vm_nsg"
}

variable "nsg_rules" {
  description = "List of NSG security rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "ssh_rule"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "vm_name" {
  description = "Virtual Machine Name"
  type        = string
  default     = "mi-primera-vm"
}

variable "vm_size" {
  description = "Virtual Machine Size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin Username"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Admin Password"
  type        = string
  sensitive   = true
}

variable "os_disk_caching" {
  description = "OS disk caching policy"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_type" {
  description = "Storage type for the OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "source_image_reference" {
  description = "Source Image Reference"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
