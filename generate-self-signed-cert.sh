#!/bin/bash

# Setting SubjectAltName (SAN) is required since Firefox 48 and Chrome 58
# https://bugzilla.mozilla.org/show_bug.cgi?id=1245280
# https://www.chromestatus.com/feature/4981025180483584

set -euo pipefail

_DOMAIN='klingt.vnet'
_KEYSIZE=2048
_SAN="DNS:*.$_DOMAIN"
_KEYFILE="./roles/caddy/files/$_DOMAIN.key"
_CERTFILE="./roles/caddy/files/$_DOMAIN.crt"
TMP_CONF="$(mktemp openssl.XXXXXX)"
echo "Temporary configuration is stored in $TMP_CONF"

cat /etc/ssl/openssl.cnf >> "$TMP_CONF"
cat <<HEREDOC>> "$TMP_CONF"
[ san ]
subjectAltName="$_SAN"
HEREDOC

openssl req\
    -x509\
    -sha256\
    -nodes\
    -newkey rsa:$_KEYSIZE\
    -days $((365*3))\
    -reqexts san\
    -extensions san\
    -subj "/CN=$_DOMAIN"\
    -config "$TMP_CONF"\
    -keyout "$_KEYFILE"\
    -out "$_CERTFILE"

openssl dhparam $_KEYSIZE >> "./roles/caddy/files/$_DOMAIN.crt"

cat <<HEREDOC
Keyfile: $_KEYFILE
Certfile: $_CERTFILE
Removing $TMP_CONF ...
HEREDOC
rm "$TMP_CONF"
