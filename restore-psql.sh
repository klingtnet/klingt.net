#!/bin/bash

set -euo pipefail

database="$1"
timestamp="$2"

fname="backups/${database}-psql-${timestamp}.xz"
echo "Restoring $fname ..."
xz --decompress --stdout "$fname" | ssh klingt.vnet "pg_restore --user=alinz --dbname=${database} --clean"
