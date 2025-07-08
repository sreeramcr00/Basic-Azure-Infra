output "private_vm_ips" {
  value = azurerm_network_interface.nic[*].private_ip_address
}
