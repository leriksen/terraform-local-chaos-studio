resource azurerm_virtual_network "vnet" {
  name = var.vnet_name
  location = var.location
  resource_group_name = var.rg
  address_space = var.vnet_range
}

resource azurerm_subnet "subnet" {
  name = var.subnet_name
  resource_group_name = var.rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], var.subnet_size, var.subnet_index)]
}