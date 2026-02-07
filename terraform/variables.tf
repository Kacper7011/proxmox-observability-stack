variable "proxmox_endpoint" {
    type = string
}

variable "proxmox_api_token" {
    type = string
    sensitive = true
}

variable "ansible_ssh_public_key_path" {
    type = string
}

variable "proxmox_ssh_private_key_path" {
    type = string
    description = "Path to SSH private key for Proxmox node access"
}