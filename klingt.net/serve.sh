#!/bin/sh
echo 'Trying to serve from localhost:8000 ...'
cd output ; python3 -m http.server &>/dev/null
