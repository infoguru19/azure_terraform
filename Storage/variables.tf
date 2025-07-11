variable "resource_group_name" {
  default = "storage-rg"
}

variable "location" {
  default = "East US"
}

variable "storage_account_name" {
  description = "Must be globally unique and all lowercase"
  default     = "demostorage${random_integer.rand.result}"
}

variable "container_name" {
  default = "mycontainer"
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}
