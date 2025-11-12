resource "proxmox_virtual_environment_vm" "image-dev-box" {

  name      = "base-image-raw"
  node_name = var.node-name
  vm_id = 301

  clone {
    vm_id = var.base_raw_vm_id
  }

  agent {
    enabled = true
  }
}


resource "proxmox_virtual_environment_vm" "base_image" {

  name      = "base-image"
  node_name = var.node-name
  vm_id = 302

  template = true

  clone {
    vm_id = proxmox_virtual_environment_vm.image-dev-box.vm_id
  }

  agent {
    enabled = true
  }
}



output "image-dev-box-ip" {
  value = proxmox_virtual_environment_vm.image-dev-box.ipv4_addresses
}


terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.86.0" # x-release-please-version
    }
  }
}
