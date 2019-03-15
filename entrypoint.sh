#!/bin/sh

cat > /etc/ssl/openssl.cnf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName_default = GB
countryName = GB
stateOrProvinceName_default = London
stateOrProvinceName = Some-State
localityName_default = Department for International Trade
localityName = Locality Name (eg, city)
organizationalUnitName_default = Digital
organizationalUnitName = Organizational Unit Name (eg, section)
commonName_default = ${DNS_NAME}
commonName = Common Name (eg, YOUR name)
commonName_max = 64
emailAddress_default = webops@digital.trade.gov.uk
emailAddress = Email Address

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
