#!/bin/sh
PORT=9000
echo "Trying to serve from localhost:$PORT ..."
cd output ; python3 -m http.server $PORT &>/dev/null
