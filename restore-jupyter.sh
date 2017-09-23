#!/bin/bash

set -euo pipefail

timestamp="$1"

ssh klingt.vnet "sudo systemctl stop jupyter"
cat "backups/jupyter-files-${timestamp}.tar.xz" | ssh klingt.vnet "sudo tar -C /home/jupyter -xJvf -"
ssh klingt.vnet "sudo systemctl start jupyter"
