
variable "vms" {
  default = [
    { name = "jumpbox", vm_id = 201 },
    { name = "server", vm_id = 202 },
    { name = "node-0",  vm_id = 203 },
    { name = "node-1",  vm_id = 204 },
  ]
}


resource "proxmox_virtual_environment_vm" "jumpbox" {
  for_each = {for inst in var.vms : inst.name => inst}

  name      = each.key
  node_name = var.node-name
  vm_id = each.value.vm_id

  cpu {
    cores = 3
  }
  
  memory {
    dedicated = 2048
  }

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
