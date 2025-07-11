provider "azurerm" {
  features {}
}

provider "azuread" {}

data "azurerm_client_config" "current" {}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["set", "get", "list", "delete"]
  }
}

# Create Azure AD Application and SP
resource "azuread_application" "app" {
  display_name = var.sp_name
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.app.application_id
}

resource "azuread_application_password" "sp_password" {
  application_id = azuread_application.app.id
  display_name   = "terraform-sp-secret"
  end_date_relative = "8760h" # 1 year
}

# Assign SP to the Resource Group
resource "azurerm_role_assignment" "sp_rg_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = var.role
  principal_id         = azuread_service_principal.sp.id
}

# Grant SP access to the Key Vault
resource "azurerm_key_vault_access_policy" "sp_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_service_principal.sp.object_id

  secret_permissions = ["get", "list"]
}

# Store SP credentials inside the Key Vault
resource "azurerm_key_vault_secret" "sp_client_id" {
  name         = "sp-client-id"
  value        = azuread_application.app.application_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "sp_client_secret" {
  name         = "sp-client-secret"
  value        = azuread_application_password.sp_password.value
  key_vault_id = azurerm_key_vault.kv.id
}
