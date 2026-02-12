locals {
  ansible_ssh_key = trimspace(
    file(var.ansible_ssh_public_key_path)
  )

  cloud_init_ansible = templatefile(
    "${path.module}/cloud-init/ansible-only.yml",
    {
      ansible_ssh_key = local.ansible_ssh_key
    }
  )

  vm_ipv4_list = [
    for ip in flatten(proxmox_virtual_environment_vm.prox-monitoring.ipv4_addresses) :
    ip if ip != "127.0.0.1"
  ]

  vm_ipv4 = try(local.vm_ipv4_list[0], null)
}