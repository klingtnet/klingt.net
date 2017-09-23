#!/bin/bash

set -euo pipefail
timestamp=$(date --iso-8601=seconds)

ssh klingt.vnet "sudo systemctl kill prometheus"
ssh klingt.vnet "sudo tar -C /home/prometheus -cf - -- data | pixz" > "backups/prometheus-files-${timestamp}.tar.xz"
ssh klingt.vnet "sudo systemctl start prometheus"
