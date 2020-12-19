#!/bin/bash

timestamp=${1:-''}
selection=${2:-''}
set -euo pipefail

domain=klingt.vnet

_psql() {
    local database="$1"
    local fname="backups/${database}-psql-${timestamp}.xz"
    echo "Restoring $fname ..."
    xz --decompress --stdout "$fname" | ssh ${domain} "pg_restore --user=alinz --dbname=${database} --clean"
}

_caddy() {
    ssh ${domain} "sudo systemctl stop caddy"
    cat "backups/caddy-files-${timestamp}.tar.xz" | ssh ${domain} "sudo tar -C /home/caddy -xJvf -"
    ssh ${domain} "sudo systemctl start caddy"
}

_gitea() {
    ssh ${domain} "sudo systemctl stop gitea"
    cat "backups/gitea-files-${timestamp}.tar.xz" | ssh ${domain} "sudo tar -C /home/gitea -xJvf -"
    _psql gitea
    ssh ${domain} "sudo systemctl start gitea"
}

_grafana() {
    ssh ${domain} "sudo systemctl stop grafana"
    _psql grafana
    ssh ${domain} "sudo systemctl start grafana"
}

_prometheus() {
    ssh ${domain} "sudo systemctl stop prometheus"
    cat "backups/prometheus-files-${timestamp}.tar.xz" | ssh ${domain} "sudo tar -C /home/prometheus -xJvf -"
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
    'prometheus')
        _prometheus
        ;;
    ''|'all')
        _caddy
        _gitea
        _grafana
        _prometheus
        ;;
esac
