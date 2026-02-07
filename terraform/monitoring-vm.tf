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

    disk {
        interface = "scsi0"
        datastore_id = "local-zfs"
        size = 50
    }

    network_device {
        bridge = "vmbr0"
    }

    initialization {
        datastore_id = "local-zfs"

        user_data_file_id = proxmox_virtual_environment_file.ansible_cloud_init.id

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