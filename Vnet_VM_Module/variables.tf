variable "location" {
  default = "East US"
}

variable "vm_username" {
  default = "azureuser"
}

variable "vm_password" {
  sensitive = true
}
