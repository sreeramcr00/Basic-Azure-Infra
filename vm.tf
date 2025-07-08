
data "azurerm_resource_group" "rg1" {
    name = "Access-rg"
}
data "azurerm_ssh_public_key" "existing" {
  name                = "learn"
  resource_group_name = data.azurerm_resource_group.rg1.name
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.name}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.nic_public.id]
  vm_size               = "Standard_B1s"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "learn"
    admin_username = "learn"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/learn/.ssh/authorized_keys"
      key_data = data.azurerm_ssh_public_key.existing.public_key
    }
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine" "private" {
  count =3
  name                  = "private-vm-${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = "Standard_B1s"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "privatevm-${count.index}"
    admin_username = "learnpvt"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/learnpvt/.ssh/authorized_keys"
      key_data = data.azurerm_ssh_public_key.existing.public_key
    }
  }

  tags = {
    environment = "staging"
  }
}
