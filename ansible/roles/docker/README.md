# Docker

This role installs and configures **Docker Engine** on Debian/Ubuntu-based systems.

Docker is installed from the official Docker APT repository. The role configures required dependencies, adds the GPG key, sets up the repository, installs Docker packages, and ensures the service is enabled and running.

After execution, the host is ready to run containers and Docker Compose v2.

---

## What this role does

* **Installs required system dependencies**
* **Adds Docker official GPG key**
* **Configures Docker APT repository**
* **Installs Docker Engine and related packages**
* **Ensures Docker service is enabled and started**
* **Creates and configures the `docker` group**
* **Optionally adds users to the docker group**

---

## Files description

| File | Description |
| :--- | :--- |
| `tasks/main.yml` | Entry point for the role. Imports all Docker-related task files. |
| `tasks/system.yml` | Performs system preparation tasks and package updates. |
| `tasks/apt.yml` | Installs required APT dependencies. |
| `tasks/gpg.yml` | Adds Docker’s official GPG key. |
| `tasks/repo.yml` | Configures the official Docker APT repository. |
| `tasks/install.yml` | Installs Docker Engine, CLI, container runtime, and Docker Compose plugin. |
| `tasks/group.yml` | Creates the `docker` group and optionally assigns users. |
| `tasks/start.yml` | Enables and starts the Docker service. |

---

## Deployment Details

* **Supported systems:** Debian / Ubuntu
* **Installation source:** Official Docker APT repository
* **Service management:** systemd
* **Compose version:** Docker Compose v2 (plugin-based)

---

## Installed Packages

The role installs:

* `docker-ce`
* `docker-ce-cli`
* `containerd.io`
* `docker-buildx-plugin`
* `docker-compose-plugin`

---

## Notes

> * Root or sudo privileges are required.
> * Users added to the `docker` group must log out and log back in for group membership to apply.
> * The role uses the official Docker repository rather than distribution-provided packages.
> * All configuration is managed as code — no manual installation steps are required.