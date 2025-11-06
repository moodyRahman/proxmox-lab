
resource "proxmox_virtual_environment_vm" "jumpbox" {
  name      = "jumpbox"
  node_name = var.node-name
  vm_id = 200

  clone {
    vm_id = var.base_vm_id
  }

  agent {
    enabled = true
  }
}

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.86.0" # x-release-please-version
    }
  }
}
