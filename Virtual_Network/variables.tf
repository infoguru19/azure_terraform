variable "resource_group_name" {
  default = "vnet-rg"
}

variable "location" {
  default = "East US"
}

variable "vnet_name" {
  default = "myVNet"
}

variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "public_subnet_name" {
  default = "public-subnet"
}

variable "private_subnet_name" {
  default = "private-subnet"
}

variable "public_subnet_prefix" {
  default = "10.0.1.0/24"
}

variable "private_subnet_prefix" {
  default = "10.0.2.0/24"
}
