resource "local_file" "ansible_inventory" {
  filename = "${path.root}/../ansible/inventories/terraform.yml"

  content = <<EOF
all:
  hosts:
    ${var.vm_name}:
      ansible_host: ${local.vm_ipv4}
      ansible_user: ansible
      ansible_ssh_private_key_file: ${var.ansible_ssh_private_key_path}
EOF
}