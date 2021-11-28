output "vnet_id" {
  description = "The id of the vNet"
  value       = azurerm_virtual_network.vnet01.id
}

output "vnet_name" {
  description = "The Name of the vNet"
  value       = azurerm_virtual_network.vnet01.name
}

output "vnet_location" {
  description = "The location of the created vNet"
  value       = azurerm_virtual_network.vnet01.location
}

output "vnet_address_space" {
  description = "The address space of created vNet"
  value       = azurerm_virtual_network.vnet01.address_space
}