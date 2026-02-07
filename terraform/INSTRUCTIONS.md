# Terraform + Proxmox – environment preparation guide

This document lists **required steps** that **must be completed in Proxmox VE** so Terraform can connect to it and work correctly.

If any step is skipped, Terraform will fail with connection or authorization errors.

---

## 1. Proxmox GUI access

- Proxmox must be accessible over HTTPS
- Port: `8006`
- You need an account with administrative permissions

If the GUI is not reachable, the API will not work.

---

## 2. API endpoint

- Open the Proxmox GUI in your browser
- Check the URL in the address bar
- **Always** append the following path:

  `/api2/json`

This is the API endpoint required by Terraform.

The API endpoint is fixed and not configurable in the GUI.

---

## 3. Create a Terraform user

Do not use `root@pam`.

In the Proxmox GUI:

1. Go to: `Datacenter → Permissions → Users`
2. Create a new user:
   - Name: `terraform`
   - Realm: `pve`
   - Password: any value (not used by Terraform)

This user is required to:
- own the API token
- receive permissions (ACL)

---

## 4. Create an API token

Terraform **requires an API token**. Username and password will not work.

In the Proxmox GUI:

1. Select the user `terraform@pve`
2. Open the **API Tokens** tab
3. Click **Add**
4. Set:
   - Token ID: `terraform`
   - Privilege Separation: **disabled**
5. Save the token
6. Copy the token secret (it cannot be retrieved again)

Without an API token, Terraform cannot authenticate.

---

## 5. API token format

The API token must be assembled using:
- user name
- realm
- token ID
- token secret

An incorrect format will result in an authentication error.

---

## 6. Assign base permissions (ACL)

An API token has **no permissions by default**.

In the Proxmox GUI:

1. Go to: `Datacenter → Permissions`
2. Add **User Permission**
3. Set:
   - Path: `/`
   - User: `terraform@pve`
   - Role: `PVEAdmin`

Without these permissions, Terraform will return `403 Forbidden`.

---

## 7. SDN permissions (required when using SDN networks)

If virtual machines are connected to **SDN-based networks**, additional permissions are required.

Without SDN permissions, Terraform will fail with `403 Forbidden` during VM creation or cloning.

In the Proxmox GUI:

1. Go to: `Datacenter → Permissions`
2. Add **User Permission**
3. Set:
   - Path: `/sdn/zones`
   - User: `terraform@pve`
   - Role: `PVESDNUser`
   - Propagate: **enabled**

This permission allows Terraform to attach VMs to SDN zones and bridges.

If SDN is not used, this step is not required.

---

## 8. Snippets datastore (required for cloud-init)

When using cloud-init with Terraform and the `bpg/proxmox` provider,
user-data must be uploaded to Proxmox as a **snippet file**.

Snippets are supported **only by Directory-type datastores**.
They are NOT supported by ZFS, LVM, or ISO-only storages.

If no snippets datastore exists, Terraform will fail when uploading cloud-init
files.

### Create a snippets datastore

In the Proxmox GUI:

1. Go to: `Datacenter → Storage`
2. Click **Add → Directory**
3. Set:
   - ID: `snippets`
   - Directory: `/var/lib/vz/snippets`
   - Content: **Snippets**
   - Nodes: select the target node(s), e.g. `pve01`
4. Save

This datastore will be used to store cloud-init user-data files uploaded by Terraform.

---

## 9. Snippets ACL permissions (required)

By default, API tokens do NOT have permission to upload files to datastores.

When using a snippets datastore, the Terraform API token must be granted
explicit permissions for that datastore path.

Without this permission, Terraform will fail when creating
`proxmox_virtual_environment_file` resources.

### Assign datastore permissions

In the Proxmox GUI:

1. Go to: `Datacenter → Permissions`
2. Add **User Permission**
3. Set:
   - Path: `/storage/snippets`
   - User: `terraform@pve`
   - Role: `PVEDatastoreAdmin`
   - Propagate: **enabled**
4. Save

This permission allows Terraform to upload cloud-init snippets to Proxmox.

## 10. SSH access to Proxmox node (required)

Some Terraform operations (e.g. uploading cloud-init snippets) require
**SSH access to the Proxmox node**, in addition to API access.

Without SSH access, Terraform will fail when creating
`proxmox_virtual_environment_file` resources.

---

### Requirements

- SSH must be enabled on the Proxmox node
- Key-based authentication is required
- The SSH user must have access to the snippets datastore

Typically, Terraform connects as `root`.

---

### Terraform configuration

The SSH private key path must be provided via a Terraform variable and set
locally in a `tfvars` file.

Example:

```hcl
proxmox_ssh_private_key_path = "/home/user/.ssh/id_ed25519"
```

