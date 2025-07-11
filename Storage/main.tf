provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.storage.primary_connection_string

  https_only     = true
  start          = timestamp()
  expiry         = timeadd(timestamp(), "24h")
  resource_types = ["object"]
  services       = ["b"]

  permissions {
    read   = true
    write  = true
    create = true
    list   = true
  }
}

resource "local_file" "demo_file" {
  content  = file("${path.module}/demo.txt")
  filename = "${path.module}/demo-temp.txt"
}

resource "azurerm_storage_blob" "demo_blob" {
  name                   = "demo.txt"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = local_file.demo_file.filename
}
