


# module "cluster" {
#   source = "./modules/cluster"
#   node-name = var.node-name
#   base_vm_id  = module.base_image.base_image_raw_id
# }

# resource "proxmox_virtual_environment_vm" "base_image" {
#   name      = "base-image"
#   node_name = var.node-name
#   vm_id = 140
#   template = true
  
#   lifecycle {
#     ignore_changes  = all
#     prevent_destroy = true
#   }
# }



variable "vms" {
  default = [
    { name = "jumpbox", vm_id = 201 },
    { name = "server", vm_id = 202 },
    { name = "node-0",  vm_id = 203 },
    { name = "node-1",  vm_id = 204 },
  ]
}



resource "proxmox_virtual_environment_vm" "cluster" {
  for_each = {for inst in var.vms : inst.name => inst}

  name      = each.key
  node_name = var.node-name
  vm_id = each.value.vm_id

  disk {
    datastore_id = "media-zfs"
    interface    = "scsi0"
    discard      = "on"
    size         = 20
  }


  cpu {
    cores = 3
  }
  
  memory {
    dedicated = 2048
  }

  clone {
    vm_id = 140
  }

  agent {
    enabled = true
  }

  initialization {
    user_account {
      username = "moody"
      password = var.cluster-password
      keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVGZIgND5Ow9kLkXLFGBtNF8z8DodHWgi1Vytxad+dQ moody@base-image"]
    }
  }
}

