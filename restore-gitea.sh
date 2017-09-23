#!/bin/bash

set -euo pipefail

timestamp="$1"

ssh klingt.vnet "sudo systemctl stop gitea"
cat "backups/gitea-files-${timestamp}.tar.xz" | ssh klingt.vnet "sudo tar -C /home/gitea -xJvf -"
./restore-psql.sh gitea $timestamp
ssh klingt.vnet "sudo systemctl start gitea"
