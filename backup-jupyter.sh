#!/bin/bash

set -euo pipefail
timestamp=$(date --iso-8601=seconds)

ssh klingt.vnet "sudo systemctl kill jupyter"
ssh klingt.vnet "sudo tar -C /home/jupyter -cf - -- notebooks | pixz" > "backups/jupyter-files-${timestamp}.tar.xz"
ssh klingt.vnet "sudo systemctl start jupyter"
