output "vm_ipv4" {
    value = try(
        proxmox_virtual_environment_vm.prox-monitoring.ipv4_addresses[0][0],
        "IP not assigned yet"
    )
}