
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

resource "proxmox_virtual_environment_vm" "worker-1" {
  name      = "worker-1"
  node_name = var.node-name
  vm_id = 201

  clone {
    vm_id = var.base_vm_id
  }

  agent {
    enabled = true
  }
}

resource "proxmox_virtual_environment_vm" "worker-2" {
  name      = "worker-2"
  node_name = var.node-name
  vm_id = 202

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
