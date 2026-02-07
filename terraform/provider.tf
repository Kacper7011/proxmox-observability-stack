terraform {
    required_version = ">= 1.6.0, < 2.0.0"

    required_providers {
      proxmox = {
        source = "bpg/proxmox"
        version = "~> 0.55"
      }
    }
}

provider "proxmox" {
    endpoint = var.proxmox_endpoint
    api_token = var.proxmox_api_token
    insecure = true

    ssh {
      username = "root"
      private_key = file(var.proxmox_ssh_private_key_path)
    }
}
