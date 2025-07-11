variable "location" {
  default = "East US"
}

variable "tenant_domain" {
  description = "Your Azure AD tenant domain (e.g., contoso.onmicrosoft.com)"
  type        = string
}

variable "user_password" {
  description = "Password for both users"
  type        = string
  sensitive   = true
}
