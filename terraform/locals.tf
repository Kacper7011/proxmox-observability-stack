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
}
