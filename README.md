# Ansible

A [series of articles](https://www.digitalocean.com/community/tutorials/an-introduction-to-configuration-management) about configuration managment at the example of Ansible.

> By using a configuration management tool, the procedure necessary for bringing up a new server or updating an existing one will be all documented in the provisioning scripts.

## Terms

- **Inventory** stores information about your servers as INI file
- **Playbook** is the entry point for Ansible provisionings (imagine it as a set of tasks)
- **Task** defines a single procedure to be executed, e.g. updating the package cache
- **Module** typically is a abstraction of a system task (more generalized task?)
- **Role** is used to organize playbooks and other files for reuse
- **Play** names a complete provision process, from start to finish
- **Facts** are variables containing information about the system, e.g. OS, hostname etc.
- **Handlers** trigger service status changes

## Services

The following list of services should be configured and deployed automatically:

- [x] caddy
- [x] gitea
- [x] prometheus
- [x] grafana
- [x] jupyter
- [x] postgres
- [x] pgweb
- [x] ~~netdata~~, node_exporter
