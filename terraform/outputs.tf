output "image-dev-box-ip" {
  value = module.dev.image-dev-box-ip
}

output "k8-ips"{
  value = module.ephemeral.k8-ips
}

output "k8-jumpbox" {
  value = module.ephemeral.k8-jumpbox
}

output "k8-control" {
  value = module.ephemeral.k8-control
}