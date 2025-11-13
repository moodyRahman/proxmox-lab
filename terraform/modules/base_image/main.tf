resource "proxmox_virtual_environment_vm" "base-image" {

  name      = "base-image"
  node_name = var.node-name
  vm_id = 160
  template = true

  agent {
    enabled = true
  }
  
  clone {
    vm_id = var.base_image_raw_id
  }
}

output "base_image_raw_id" {
    value = proxmox_virtual_environment_vm.base-image.vm_id
}

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
    }
  }
}
