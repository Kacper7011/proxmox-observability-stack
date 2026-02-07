resource "proxmox_virtual_environment_vm" "prox-monitoring" {
    name = "prox-monitoring"
    node_name = "pve01"

    cpu {
        cores = 2
    }

    memory {
        dedicated = 4096
        floating  = 4096
    }

    network_device {
        bridge = "vmbr0"
    }

    initialization {
        datastore_id = "local-zfs"
      ip_config {
        ipv4 {
          address = "dhcp"
        }
      }
    }

    clone {
        vm_id = 9000
    }
}