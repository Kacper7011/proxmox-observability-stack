output "vm_ipv4" {
  value = one([
    for ip in flatten(proxmox_virtual_environment_vm.prox-monitoring.ipv4_addresses) :
    ip if ip != "127.0.0.1"
  ])
}
