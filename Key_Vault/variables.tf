variable "resource_group_name" {
  default = "rg-keyvault-demo"
}

variable "location" {
  default = "East US"
}

variable "key_vault_name" {
  default = "keyvaultdemo12345"  # Must be globally unique and 3-24 chars, alphanumeric only
}
