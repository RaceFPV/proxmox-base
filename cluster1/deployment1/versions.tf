terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
    powerdns = {
      source = "pan-net/powerdns"
      version = "1.5.0"
    }
  }
}