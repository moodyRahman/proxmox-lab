terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.86.0" # x-release-please-version
    }
  }
}


provider "proxmox" {
  endpoint = "https://ermes:8006"
  insecure = true
  username = var.proxmox-username
  password = var.proxmox-password
}