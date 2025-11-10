resource "proxmox_virtual_environment_vm" "base_template" {
  name      = "base-image-old-part"
  node_name = var.node-name
  vm_id = 106
  template = true
  
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "proxmox_virtual_environment_vm" "base_template_raw" {
  name      = "base-image-raw"
  node_name = var.node-name
  vm_id = 104
  template = true
  
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}


output "base_template_vm_id" {
  value = proxmox_virtual_environment_vm.base_template.vm_id
}

output "base_template_raw_vm_id" {
  value = proxmox_virtual_environment_vm.base_template_raw.vm_id
}

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
    }
  }
}
