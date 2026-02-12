# Node Exporter

This role installs and configures **Node Exporter** as part of a monitoring stack based on Prometheus.

Node Exporter is deployed using **Docker** and **Docker Compose v2**. It exposes system-level metrics from the host machine, which can be scraped by Prometheus.

After deployment, Node Exporter is immediately available on the configured port and ready to be scraped.

---

## What this role does

* **Creates required directories** on the target host.
* **Deploys Docker Compose configuration** for Node Exporter.
* **Configures container runtime options** (network mode, volumes, restart policy).
* **Starts or updates the Node Exporter container** using Docker Compose v2.

---

## Files description

| File / Directory | Description |
| :--- | :--- |
| `tasks/main.yml` | Entry point for the role. Imports `directory.yml`, `deploy.yml`, and `start.yml`. |
| `tasks/directory.yml` | Creates the `/opt/node-exporter` directory on the target host. |
| `tasks/deploy.yml` | Deploys `docker-compose.yml` from a template. |
| `tasks/start.yml` | Starts or updates Node Exporter using `community.docker.docker_compose_v2`. |
| `templates/docker-compose.yml.j2` | Template defining the Node Exporter service, volumes, network mode, and restart policy. |

---

## Deployment Details

* **Installation path:** `/opt/node-exporter`
* **Default port:** `9100`
* **Orchestration:** Docker Compose v2
* **Container lifecycle:** Managed declaratively (`state: present`)
* **Metrics endpoint:** `http://<host>:9100/metrics`

---

## Notes

> * This role assumes Docker and Docker Compose v2 are already installed on the target host.
> * Node Exporter runs with access to host system metrics via mounted system paths (e.g., `/proc`, `/sys`).
> * No additional configuration is required unless custom collectors or flags are needed.
> * All configuration is managed as code — no manual edits on the host are required.