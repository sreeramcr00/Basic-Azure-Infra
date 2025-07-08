terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name = "${var.name}-rg"
  location = "West Europe"
}

# resource "azurerm_network_security_group" "mainsg" {
#   name                = "${var.name}-sg"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   security_rule {
#     name                       = "allow-ssh"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# resource "azurerm_virtual_network" "mainvnet" {
#   name                = "${var.name}-vnet"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   address_space       = ["10.0.0.0/16"]
# }

# resource "azurerm_subnet" "subnet1" {
#   name                 = "subnet1"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.mainvnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }
# resource "azurerm_subnet_network_security_group_association" "example" {
#   subnet_id                 = azurerm_subnet.subnet1.id
#   network_security_group_id = azurerm_network_security_group.mainsg.id
# }


# resource "azurerm_network_interface" "nic" {
#   name                = "${var.name}-nic"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   ip_configuration {
#     name                          = "testconfiguration1"
#     subnet_id                     = azurerm_subnet.subnet1.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_public_ip" "vm_public_ip" {
#   name                = "${var.name}-public-ip"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   allocation_method   = "Dynamic"

#   sku = "Basic"

#   tags = {
#     environment = "staging"
#   }
# }
# resource "azurerm_subnet" "public_subnet" {
#   name                 = "public-subnet"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.mainvnet.name
#   address_prefixes     = ["10.0.2.0/24"]
# }
# resource "azurerm_subnet_network_security_group_association" "public_assoc" {
#   subnet_id                 = azurerm_subnet.public_subnet.id
#   network_security_group_id = azurerm_network_security_group.mainsg.id
# }
# resource "azurerm_network_interface" "nic_public" {
#   name                = "${var.name}-nic-public"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   ip_configuration {
#     name                          = "ipconfig1"
#     subnet_id                     = azurerm_subnet.public_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
#   }
# }

# data "azurerm_resource_group" "rg1" {
#     name = "Access-rg"
# }
# data "azurerm_ssh_public_key" "existing" {
#   name                = "learn"
#   resource_group_name = data.azurerm_resource_group.rg1.name
# }

# resource "azurerm_virtual_machine" "main" {
#   name                  = "${var.name}-vm"
#   location              = azurerm_resource_group.main.location
#   resource_group_name   = azurerm_resource_group.main.name
#   network_interface_ids = [azurerm_network_interface.nic_public.id]
#   vm_size               = "Standard_B1s"

#   delete_os_disk_on_termination    = true
#   delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "learn"
#     admin_username = "learn"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = true

#     ssh_keys {
#       path     = "/home/learn/.ssh/authorized_keys"
#       key_data = data.azurerm_ssh_public_key.existing.public_key
#     }
#   }

#   tags = {
#     environment = "staging"
#   }
# }
