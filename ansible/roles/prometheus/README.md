# Prometheus

This role installs and configures **Prometheus** as part of a monitoring stack.

Prometheus is deployed using **Docker** and **Docker Compose v2**. The configuration is fully managed through Ansible templates, allowing Prometheus to be deployed and updated without manual changes on the target host.

After deployment, Prometheus is ready to scrape configured targets immediately.

---

## What this role does

* **Creates required directories** on the target host.
* **Deploys Docker Compose configuration** for Prometheus.
* **Deploys Prometheus configuration** (`prometheus.yml`) from a template.
* **Starts or updates the Prometheus container** using Docker Compose v2.
* **Triggers configuration reload** when the Prometheus configuration changes.

---

## Files description

| File / Directory | Description |
| :--- | :--- |
| `tasks/main.yml` | Entry point for the role. Imports `directory.yml`, `deploy.yml`, and `start.yml`. |
| `tasks/directory.yml` | Creates the `/opt/prometheus` directory on the target host. |
| `tasks/deploy.yml` | Deploys `docker-compose.yml` and `prometheus.yml` from templates. |
| `tasks/start.yml` | Starts or updates Prometheus using `community.docker.docker_compose_v2`. |
| `templates/docker-compose.yml.j2` | Template defining the Prometheus service, volumes, and ports. |
| `templates/prometheus.yml.j2` | Template containing the Prometheus scrape configuration. |
| `handlers/main.yml` | Contains handler for reloading Prometheus configuration (if defined). |

---

## Deployment Details

* **Installation path:** `/opt/prometheus`
* **Orchestration:** Docker Compose v2
* **Configuration management:** Fully template-based via Ansible
* **Container lifecycle:** Managed declaratively (`state: present`)

---

## Notes

> * This role assumes Docker and Docker Compose v2 are already installed on the target host.
> * Any changes to `prometheus.yml` trigger a configuration reload via handler.
> * All configuration is managed as code — no manual edits on the host are required.