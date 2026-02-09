# Grafana

This role installs and configures **Grafana** as part of an observability stack based on Prometheus and Node Exporter.

Grafana is deployed using **Docker** and is fully configured automatically using **Grafana provisioning**. After deployment, Grafana is ready to use without any manual configuration in the web interface.

---

## What this role does

* **Deploys Grafana** using Docker and Docker Compose.
* **Enables persistent storage** for Grafana data.
* **Configures Prometheus** as a datasource automatically.
* **Provisions dashboards** from JSON files.
* **Optionally installs** additional Grafana plugins.

---

## Files description

| File / Directory | Description |
| :--- | :--- |
| `defaults/main.yml` | Defines default configuration values (Docker image, port, admin password, plugins, Prometheus URL). |
| `tasks/directory.yml` | Creates required directories on the target host for data and provisioning. |
| `tasks/provisioning.yml` | Handles deployment of datasource and dashboard provisioning files. |
| `tasks/deploy.yml` | Deploys the Docker Compose configuration using an Ansible template. |
| `tasks/start.yml` | Starts or updates the Grafana container using Docker Compose v2. |
| `templates/docker-compose.yml.j2` | Template defining the Grafana service, volumes, and environment variables. |
| `templates/datasources.yml.j2` | Provisioning file that automatically configures Prometheus as the default datasource. |
| `templates/dashboards.yml.j2` | Configuration that instructs Grafana to load dashboards from the dashboards directory. |
| `files/dashboards/` | Contains Grafana dashboard definitions in JSON format for automatic import. |

---

## Notes

> * **Default Password:** The default admin password is set to `admin`. Grafana enforces changing this password on the first login.
> * **Infrastructure as Code:** All configuration is managed through code; no manual UI setup is required.