terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.47.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

data "azurerm_client_config" "current" {}

# Create Azure AD Users
resource "azuread_user" "readuser" {
  user_principal_name = "readuser@${var.tenant_domain}"
  display_name        = "Read Only User"
  mail_nickname       = "readuser"
  password            = var.user_password
  force_password_change = false
}

resource "azuread_user" "writeuser" {
  user_principal_name = "writeuser@${var.tenant_domain}"
  display_name        = "Write User"
  mail_nickname       = "writeuser"
  password            = var.user_password
  force_password_change = false
}

# Create Group and Add writeuser
resource "azuread_group" "prdgroup" {
  display_name     = "prdgroup"
  security_enabled = true
  members          = [azuread_user.writeuser.id]
}

# Create Resource Groups
resource "azurerm_resource_group" "read_rg" {
  name     = "readRG"
  location = var.location
}

resource "azurerm_resource_group" "write_rg" {
  name     = "writeRG"
  location = var.location
}

# Assign Reader role to readuser on readRG
resource "azurerm_role_assignment" "readuser_readrg" {
  scope                = azurerm_resource_group.read_rg.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.readuser.object_id
}

# Assign Contributor role to prdgroup on writeRG
resource "azurerm_role_assignment" "group_writerg" {
  scope                = azurerm_resource_group.write_rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.prdgroup.object_id
}
