#!/bin/sh

cat > /etc/ssl/openssl.cnf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = GB
stateOrProvinceName = London
localityName = Department for International Trade
organizationalUnitName = Digital
commonName = ${DNS_NAME}
emailAddress = webops@digital.trade.gov.uk

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
EOF

pritunl set-mongodb ${MONGODB_URI}
pritunl set app.reverse_proxy true
pritunl set app.server_ssl ${SSL_ENABLED:-true}
pritunl set app.server_port ${WEB_PORT:-443}

exec $@
