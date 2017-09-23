#!/bin/bash

set -euo pipefail
timestamp=$(date --iso-8601=seconds)

ssh klingt.vnet "sudo systemctl stop grafana"
./backup-psql.sh grafana $timestamp
ssh klingt.vnet "sudo systemctl start grafana"
