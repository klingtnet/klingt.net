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
    local fname="backups/caddy-files-${timestamp}.tar.xz"
    echo "Creating $fname ..."
    # backup 'restic files.${domain}' in a separate target
    ssh ${domain} "sudo tar -C /home/caddy -cf - -- certs | pixz" > "$fname"
    ssh ${domain} "sudo systemctl start caddy"
}

_gitea() {
    ssh ${domain} "sudo systemctl stop gitea"
    local fname="backups/gitea-files-${timestamp}.tar.xz"
    echo "Creating $fname ..."
    ssh ${domain} "sudo tar -C /home/gitea -cf - -- gitea | pixz" > "$fname"
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
    local fname="backups/jupyter-files-${timestamp}.tar.xz"
    echo "Creating $fname ..."
    ssh ${domain} "sudo tar -C /home/jupyter -cf - -- notebooks .julia | pixz" > "$fname"
    ssh ${domain} "sudo systemctl start jupyter"
}

_prometheus() {
    ssh ${domain} "sudo systemctl kill prometheus"
    local fname="backups/prometheus-files-${timestamp}.tar.xz"
    echo "Creating $fname ..."
    ssh ${domain} "sudo tar -C /home/prometheus -cf - -- data | pixz" > "$fname"
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
    'important')
        _caddy
        _gitea
        _grafana
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
