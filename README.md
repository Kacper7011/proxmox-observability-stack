# Proxmox Observability Stack

This repository contains an infrastructure project focused on building a portable observability stack using modern DevOps tools.

The goal of this project is to provision virtual machines on a Proxmox cluster using Terraform and then configure them with Ansible to run a full monitoring stack based on Docker, Prometheus, Grafana, and node-exporter.

The project is designed as an infrastructure-first setup:
- Terraform is responsible only for provisioning virtual machines
- Ansible handles system configuration and service deployment
- Docker is used as the runtime for all monitoring components

At this stage, the repository serves as a working foundation and will be expanded iteratively as the project evolves.

## Planned Stack

- Proxmox (VM hosting)
- Terraform (infrastructure provisioning)
- Ansible (configuration management)
- Docker (container runtime)
- Prometheus (metrics collection)
- Grafana (visualization)
- node-exporter (system metrics)

## Project Status

🚧 Work in progress  
This repository is under active development and structure, roles, and playbooks are subject to change.

## Notes

Secrets, credentials, Terraform state files, and runtime data are intentionally excluded from version control.
