output "bastion_dns" {
  value = "https://${module.network.vnet_id}.portal.azure.com"
}

output "vm_id" {
  value = module.vm.vm_id
}

output "vm_private_ip" {
  value = module.vm.private_ip_address
}