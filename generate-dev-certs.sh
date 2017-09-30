#!/bin/bash

set -euo pipefail

years=3
domain='klingt.vnet'
cert_out_path='./roles/caddy/files'
root_out_path="${HOME}/.ssl"
csr_cnf_file="$(mktemp)"
v3_ext_file="$(mktemp)"

[[ ! -e "${root_out_path}/root-ca.key" ]] &&\
    openssl genrsa\
        -out "${root_out_path}/root-ca.key"\
        2048

cat <<HEREDOC > "${csr_cnf_file}"
[req]
default_bits=2048
prompt=no
default_md=sha256
distinguished_name=dn

[dn]
C=DE
ST=Leipzig
L=Saxony
O=klingt.vnet
OU=klingt.vnet
emailAddress=admin@klingt.vnet
CN=klingt.vnet
HEREDOC

[[ ! -e "${root_out_path}/root-ca.pem" ]] &&\
    openssl req\
        -x509\
        -new\
        -nodes\
        -key "${root_out_path}/root-ca.key"\
        -sha256\
        -days $((365 * $years))\
        -out "${root_out_path}/root-ca.pem"\
        -config <(cat "${csr_cnf_file}")

cat <<HEREDOC > "${v3_ext_file}"
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = klingt.vnet
DNS.2 = *.klingt.vnet
HEREDOC

openssl req\
    -new\
    -sha256\
    -nodes\
    -out "${cert_out_path}/${domain}.csr"\
    -newkey rsa:2048\
    -keyout "${cert_out_path}/${domain}.key"\
    -config <(cat "${csr_cnf_file}")

openssl x509\
    -req\
    -in "${cert_out_path}/${domain}.csr"\
    -CA "${root_out_path}/root-ca.pem"\
    -CAkey "${root_out_path}/root-ca.key"\
    -CAcreateserial\
    -out "${cert_out_path}/${domain}.crt"\
    -days $((365 * $years))\
    -sha256\
    -extfile "${v3_ext_file}"

rm "${csr_cnf_file}" "${v3_ext_file}" "${cert_out_path}/${domain}.csr"
