#!/bin/bash

set -euo pipefail

timestamp="$1"

ssh klingt.vnet "sudo systemctl stop prometheus"
cat "backups/prometheus-files-${timestamp}.tar.xz" | ssh klingt.vnet "sudo tar -C /home/prometheus -xJvf -"
ssh klingt.vnet "sudo systemctl start prometheus"
