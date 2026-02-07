# Proxmox – Ubuntu Cloud-Init VM Template Preparation Guide

This document describes the **exact, validated procedure** for creating a **working Ubuntu cloud-init VM template** in Proxmox VE, intended for use with **Terraform and Ansible**.

The steps below are based on real-world troubleshooting and avoid common Proxmox + cloud-image boot issues.

If any step is skipped or modified, the resulting VM may fail to boot.

---

## 1. Supported operating system

This guide is written for:

- **Ubuntu Server 22.04 LTS (Jammy)**
- Official **cloud image** from Ubuntu

Other images or ISO installers are **not supported** by this procedure.

---

## 2. Download the Ubuntu cloud image

On the Proxmox node where the template will be created (e.g. `pve01`):

```bash
cd /var/lib/vz/template/iso
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```
## Important notes

- Do **not** use an installer ISO  
- The cloud image already contains built-in **cloud-init** support

---

## 3. Create an empty VM (no disks)

In the **Proxmox GUI**:

### General
- **VM ID:** e.g. `9000`
- **Name:** `ubuntu-22.04-cloudinit`
- **Node:** target node (e.g. `pve01`)
- **Start at boot:** disabled

### OS
- Select **Do not use any media**

### System
- **BIOS:** SeaBIOS
- **Machine:** q35
- **SCSI Controller:** VirtIO SCSI single
- **QEMU Guest Agent:** enabled

> Do **not** use UEFI / OVMF.  
> Ubuntu cloud images are most reliable with SeaBIOS in Proxmox.

### Disks
- **Do not add any disk**

This is **critical**.  
The system disk will be imported manually in the next step.

### CPU / Memory
- Any values  
  (they will be overridden later by Terraform)

### Network
- **Model:** VirtIO
- **Bridge:** e.g. `vmbr0`

### Confirm
- Create the VM

---

## 4. Import the cloud image as the system disk

On the Proxmox host:

```bash
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-zfs
```

## 4. Attach the imported system disk

Then in the **Proxmox GUI**:

1. Open the VM → **Hardware**
2. You will see **Unused Disk 0**
3. Click **Edit → Attach**
4. Set:
   - **Bus / Device:** SCSI
   - **Device:** `scsi0`
   - **Storage:** `local-zfs`
5. Save

This disk is now the **only system disk**.

---

## 5. Add Cloud-Init drive

In **VM → Hardware**:

1. Click **Add → CloudInit Drive**
2. **Storage:** `local-zfs`

**Do not configure:**
- users
- passwords
- SSH keys

All cloud-init configuration will be injected by **Terraform**.

---

## 6. Boot order configuration

In **Options → Boot Order**:

- Set boot order to:
  - `scsi0`
- Remove all other boot devices

---

## 7. Verify hardware configuration

At this point, the VM must contain **exactly**:

- **Hard Disk (scsi0)** – Ubuntu cloud image
- **CloudInit Drive (ide0)**
- **Network Device**

The VM must **not** contain:

- EFI Disk
- Additional hard disks

**Required settings:**
- **BIOS:** SeaBIOS

If any extra disks are present, remove them.

---

## 8. Convert the VM to a template

- **Do not start the VM**
- Right-click the VM
- Select **Convert to Template**

The template is now ready for Terraform.

---

## 9. Expected behavior when cloned

When a VM is created from this template using Terraform:

- The system boots immediately
- `cloud-init` executes correctly
- Networking works via DHCP
- QEMU Guest Agent reports the IP address
- No manual intervention is required

---

## 10. Common mistakes to avoid

- Using UEFI / OVMF instead of SeaBIOS
- Adding a disk during VM creation
- Having more than one hard disk in the template
- Booting the VM before converting it to a template
- Using a non-cloud Ubuntu image or installer ISO

---

## 11. Summary

This procedure produces a **minimal, reliable, Terraform-ready Ubuntu template**.

The template contains:

- a single bootable system disk
- cloud-init support
- no hardcoded users or secrets
- no runtime configuration

