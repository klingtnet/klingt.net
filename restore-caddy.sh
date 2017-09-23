#!/bin/bash

set -euo pipefail

timestamp="$1"

ssh klingt.vnet "sudo systemctl stop caddy"
cat "backups/caddy-files-${timestamp}.tar.xz" | ssh klingt.vnet "sudo tar -C /home/caddy -xJvf -"
ssh klingt.vnet "sudo systemctl start caddy"
