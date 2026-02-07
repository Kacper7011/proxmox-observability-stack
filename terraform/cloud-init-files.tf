resource "proxmox_virtual_environment_file" "ansible_cloud_init" {
  content_type = "snippets"
  datastore_id = "snippets"
  node_name    = "pve01"

  source_raw {
    data = local.cloud_init_ansible
    file_name = "ansible-only.cloud-init.yaml"
  }
}
