resource "local_file" "ansible_inventory" {
  filename = "${path.root}/../ansible/inventories/terraform.yml"

  content = <<EOF
all:
  hosts:
    ${var.vm_name}:
      ansible_host: ${one([
        for ip in flatten(proxmox_virtual_environment_vm.prox-monitoring.ipv4_addresses) :
        ip if ip != "127.0.0.1"
      ])}
      ansible_user: ansible
      ansible_ssh_private_key_file: ${var.ansible_ssh_private_key_path}
EOF
}
