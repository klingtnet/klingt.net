#!/bin/bash

set -euo pipefail

database="$1"
timestamp="${2:-$(date --iso-8601=seconds)}"

fname="backups/${database}-psql-${timestamp}.xz"
echo "Creating $fname ..."
ssh klingt.vnet "pg_dump --user=alinz $database --format=custom | pixz" > "$fname"
