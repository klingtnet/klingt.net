#!/bin/bash

selection=${1:-''}
set -euo pipefail

[[ ! -e './backups' ]] && mkdir backups

timestamp=$(date --iso-8601=seconds)
domain=klingt.net

_psql() {
    local database="$1"
    local fname="backups/${database}-psql-${timestamp}.xz"
    echo "Creating $fname ..."
    ssh ${domain} "pg_dump --user=alinz $database --format=custom | pixz" > "$fname"
}

_caddy() {
    ssh ${domain} "sudo systemctl stop caddy"
    # backup 'restic files.${domain}' in a separate target
    ssh ${domain} "sudo tar -C /home/caddy -cf - -- certs | pixz" > "backups/caddy-files-${timestamp}.tar.xz"
    ssh ${domain} "sudo systemctl start caddy"
}

_gitea() {
    ssh ${domain} "sudo systemctl stop gitea"
    ssh ${domain} "sudo tar -C /home/gitea -cf - -- gitea | pixz" > "backups/gitea-files-${timestamp}.tar.xz"
    _psql gitea $timestamp
    ssh ${domain} "sudo systemctl start gitea"
}

_grafana() {
    ssh ${domain} "sudo systemctl stop grafana"
    _psql grafana $timestamp
    ssh ${domain} "sudo systemctl start grafana"
}

_jupyter() {
    ssh ${domain} "sudo systemctl kill jupyter"
    ssh ${domain} "sudo tar -C /home/jupyter -cf - -- notebooks .julia | pixz" > "backups/jupyter-files-${timestamp}.tar.xz"
    ssh ${domain} "sudo systemctl start jupyter"
}

_prometheus() {
    ssh ${domain} "sudo systemctl kill prometheus"
    ssh ${domain} "sudo tar -C /home/prometheus -cf - -- data | pixz" > "backups/prometheus-files-${timestamp}.tar.xz"
    ssh ${domain} "sudo systemctl start prometheus"
}

case "$selection" in
    'caddy')
        _caddy
        ;;
    'gitea')
        _gitea
        ;;
    'grafana')
        _grafana
        ;;
    'jupyter')
        _jupyter
        ;;
    'prometheus')
        _prometheus
        ;;
    ''|'all')
        _caddy
        _gitea
        _grafana
        _jupyter
        _prometheus
        ;;
esac
