variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "rg-sp-kv"
}

variable "key_vault_name" {
  default = "kvspdemo123" # must be globally unique
}

variable "sp_name" {
  default = "terraform-sp"
}

variable "role" {
  default = "Contributor"
}
