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

## 8. TLS certificate

If Proxmox uses:
- a self-signed certificate
- or a certificate from an unknown CA

Terraform will reject the HTTPS connection.

You must either:
- allow insecure TLS connections (lab setup)
- or install a trusted certificate (production)

This is required for connectivity.

---

## 9. Secret handling

The API token:
- must not be committed to the repository
- should be stored locally or in a secrets manager

Terraform:
- stores secrets in the state file as plaintext
- therefore state files must never be committed

---

## 10. Repository rules

The repository must:
- ignore Terraform state files
- ignore variable files containing secrets
- include the `.terraform.lock.hcl` file

Without the lock file, the setup is not reproducible.

---

## 11. Conditions for a working setup

Terraform will work only if:

- Proxmox GUI is reachable
- the API endpoint is correct
- a technical user exists
- an API token exists
- the token has ACL permissions
- SDN permissions are present when SDN is used
- TLS does not block HTTPS
- secrets are not stored in the repository

Missing any item will cause initialization or authorization errors.

---

## 12. Environment changes

Any change to:
- users
- API tokens
- ACL permissions
- SDN configuration
- TLS certificates
- Proxmox address

requires updating the Terraform configuration.

These changes are not detected automatically.
