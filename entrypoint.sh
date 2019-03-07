#!/bin/sh

pritunl set-mongodb ${MONGODB_URI}
pritunl set app.reverse_proxy true
pritunl set app.server_ssl ${SSL_ENABLED}
pritunl set app.server_port ${WEB_PORT}

exec $@
