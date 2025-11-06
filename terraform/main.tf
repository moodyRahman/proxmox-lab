resource "proxmox_virtual_environment_vm" "base_template" {
  name      = "base-image"
  node_name = var.node-name
  vm_id = 102
  template = true
  
  lifecycle {
    ignore_changes  = all
  }
}


resource "proxmox_virtual_environment_vm" "jumpbox" {
  name      = "jumpbox"
  node_name = var.node-name
  vm_id = 200

  clone {
    vm_id = proxmox_virtual_environment_vm.base_template.vm_id
  }

  agent {
    enabled = true
  }

  # memory {
  #   dedicated = 768
  # }

  # initialization {
  #   dns {
  #     servers = ["1.1.1.1"]
  #   }
  #   ip_config {
  #     ipv4 {
  #       address = "dhcp"
  #     }
  #   }
  # }
}
