#!/bin/bash

set -euo pipefail
timestamp=$(date --iso-8601=seconds)

ssh klingt.vnet "sudo systemctl stop caddy"
ssh klingt.vnet "sudo tar -C /home/caddy -cf - -- certs restic files.klingt.vnet | pixz" > "backups/caddy-files-${timestamp}.tar.xz"
ssh klingt.vnet "sudo systemctl start caddy"
