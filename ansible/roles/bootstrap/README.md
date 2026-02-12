# Bootstrap

This role prepares a fresh Linux server for further automation and deployment.

It performs essential system configuration tasks such as hostname setup, user management, SSH hardening, sudo configuration, time synchronization, and base system updates.  

The role is intended to be executed on newly provisioned hosts before deploying application or infrastructure roles.

---

## What this role does

* **Configures system hostname**
* **Creates and manages users**
* **Configures SSH access and hardening**
* **Configures sudo privileges**
* **Sets system timezone and time synchronization**
* **Performs basic system configuration and updates**

---

## Files description

| File | Description |
| :--- | :--- |
| `tasks/main.yml` | Entry point for the role. Imports all bootstrap task files. |
| `tasks/hostname.yml` | Sets the system hostname. |
| `tasks/users.yml` | Creates users and configures SSH authorized keys. |
| `tasks/ssh.yml` | Configures SSH daemon settings (e.g., disabling password authentication, root login policy). |
| `tasks/sudo.yml` | Configures sudo access for defined users or groups. |
| `tasks/time.yml` | Configures timezone and time synchronization settings. |
| `tasks/system.yml` | Performs base system configuration tasks and package updates. |

---

## Deployment Details

* **Target systems:** Fresh Linux hosts
* **Execution stage:** Initial provisioning
* **Privileges required:** Root or sudo access
* **Configuration management:** Fully defined in Ansible tasks

---

## Notes

> * This role should be executed before infrastructure roles such as Docker, Prometheus, Grafana, or Node Exporter.
> * It is recommended to disable SSH password authentication and root login for production environments.
> * Ensure at least one administrative user with SSH key access is configured before restricting SSH access.
> * All system configuration is managed as code — no manual server preparation is required.