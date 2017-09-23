#!/bin/bash

set -euo pipefail
timestamp=$(date --iso-8601=seconds)

ssh klingt.vnet "sudo systemctl stop gitea"
ssh klingt.vnet "sudo tar -C /home/gitea -cf - -- gitea | pixz" > "backups/gitea-files-${timestamp}.tar.xz"
./backup-psql.sh gitea $timestamp
ssh klingt.vnet "sudo systemctl start gitea"
