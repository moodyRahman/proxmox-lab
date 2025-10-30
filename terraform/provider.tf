provider "proxmox" {
  endpoint = "https://ermes:8006"
  insecure = true
  username = var.proxmox-username
  password = var.proxmox-password
}