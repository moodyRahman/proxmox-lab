# output "image-dev-box-ip" {
#   value = module.dev.image-dev-box-ip
# }

output "k8-ips" {
  value = flatten([
    for vm in proxmox_virtual_environment_vm.cluster :
    vm.ipv4_addresses
  ])
}

# output "k8-jumpbox" {
#   value = module.ephemeral.k8-jumpbox
# }

# output "k8-control" {
#   value = module.ephemeral.k8-control
# }

