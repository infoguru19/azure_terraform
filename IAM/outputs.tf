output "readuser_upn" {
  value = azuread_user.readuser.user_principal_name
}

output "writeuser_upn" {
  value = azuread_user.writeuser.user_principal_name
}

output "prdgroup_id" {
  value = azuread_group.prdgroup.id
}
