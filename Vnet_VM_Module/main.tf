provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-complete"
  location = var.location
}

module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = "main-vnet"
  address_space       = ["10.0.0.0/16"]
}

module "vm" {
  source              = "./modules/vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.private_subnet_id
  username            = var.vm_username
  password            = var.vm_password
}
