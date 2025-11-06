resource "proxmox_virtual_environment_vm" "base_template" {
  name      = "base-image"
  node_name = var.node-name
  vm_id = 102
  template = true
  
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

output "base_template_vm_id" {
  value = proxmox_virtual_environment_vm.base_template.vm_id
}


terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
    }
  }
}
