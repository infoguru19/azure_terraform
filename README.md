# azure_terraform

# ⚙️ Azure Infrastructure Provisioning with Terraform

This repository contains a **modular, production-ready Terraform setup** to deploy infrastructure on Microsoft Azure. It focuses on:

- 🔒 Secure network architecture (VNet, NSGs, subnets)
- 🖥️ Virtual Machines (public & private)
- 🔄 NAT Gateway or Azure Bastion for secure access
- 🔑 Role assignments and Key Vault integration
- ♻️ Reusable, environment-agnostic modules

---

## 📦 Features

✅ Virtual Network (VNet) with custom CIDRs  
✅ Public & private subnets with NSGs  
✅ VM deployment with OS disk settings, credentials, and tagging  
✅ Optional NAT Gateway or Azure Bastion for private VM access  
✅ Role assignment for Service Principals  
✅ Key Vault integration for secrets storage  
✅ Modular code with support for multiple environments

---

## 📁 Directory Structure

```bash
terraform/
├── main.tf               # Root configuration
├── variables.tf          # Input variables
├── outputs.tf            # Output values
├── terraform.tfvars      # Default values
├── modules/              # Reusable modules
│   ├── vnet/
│   ├── nsg/
│   ├── subnet/
│   ├── vm/
│   ├── bastion/
│   ├── nat_gateway/
│   └── keyvault/
```
## 🚀 Quick Start
### 1. Prerequisites
- Terraform CLI
- Azure CLI
- An Azure subscription
- (Optional) A Service Principal for automation

### 2. Authenticate with Azure
```bash
az login
```
- For automation, create a Service Principal:

```bash
az ad sp create-for-rbac --name terraform-sp --role Contributor \
  --scopes /subscriptions/<subscription-id>/resourceGroups/<resource-group>
```
### 3. Configure Inputs
Edit terraform.tfvars:
```bash
location        = "eastus"
resource_group  = "rg-terraform-demo"
vnet_cidr       = "10.1.0.0/16"
public_subnet   = "10.1.1.0/24"
private_subnet  = "10.1.2.0/24"
admin_username  = "azureuser"
admin_password  = "SuperSecureP@ss123"
enable_bastion  = true
```
### 4. Deploy Infrastructure
```bash

terraform init
terraform plan -out tfplan
terraform apply tfplan
```
- 🔁 Module Usage Example
```bash

module "vnet" {
  source     = "./modules/vnet"
  name       = "demo-vnet"
  cidr_block = var.vnet_cidr
  location   = var.location
  rg_name    = var.resource_group
}

module "vm" {
  source           = "./modules/vm"
  name             = "web-vm"
  subnet_id        = module.vnet.public_subnet_id
  username         = var.admin_username
  password         = var.admin_password
  is_public        = true
}
```
## 🔐 Security & Best Practices
- NSGs restrict access to only required ports (SSH, RDP, HTTP/S).
- Passwords/secrets can be injected securely from Azure Key Vault.
- Supports RBAC: Assign Service Principal to resource group via Terraform.

```bash
resource "azurerm_role_assignment" "sp_rg_access" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = var.sp_object_id
}
```
## 📤 CI/CD Integration (Optional)
To integrate with GitHub Actions, store secrets like:

- ARM_CLIENT_ID

- ARM_CLIENT_SECRET

- ARM_SUBSCRIPTION_ID

- ARM_TENANT_ID


## 🧹 Clean Up
```bash
terraform destroy -auto-approve
```

### 🙋‍♂️ Need Help?
Open an issue or start a discussion in this repository.
Made with ❤️ for DevOps & Cloud Automation