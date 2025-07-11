output "client_id" {
  value = azuread_application.app.application_id
}

output "client_secret" {
  value     = azuread_application_password.sp_password.value
  sensitive = true
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}
