resource "proxmox_virtual_environment_vm" "base_template" {
  name      = "base-image"
  node_name = "ermes"
  vm_id = 102
  template = true
}
