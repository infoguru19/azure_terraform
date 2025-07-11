output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

output "secret_id" {
  value = azurerm_key_vault_secret.demo.id
}
