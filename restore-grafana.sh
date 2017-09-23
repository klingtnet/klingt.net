#!/bin/bash

set -euo pipefail

timestamp="$1"

ssh klingt.vnet "sudo systemctl stop grafana"
./restore-psql.sh grafana $timestamp
ssh klingt.vnet "sudo systemctl start grafana"
