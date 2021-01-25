FROM alpine:3.10

ENV BUILD_DEPS curl gcc git go musl-dev libffi-dev linux-headers openssl-dev py-pip python-dev make
ENV RUNTIME_DEPS openvpn libressl ca-certificates python py-setuptools

ENV PRITUNL_VERSION 1.29.2664.67
ENV PRITUNL_SHA1 5c6788fa43b7f12d3d609d8e7af775677457de7d
ENV PRITUNL_URL https://github.com/pritunl/pritunl/archive/${PRITUNL_VERSION}.tar.gz

RUN set -e \
    && cd /tmp \
    #
    # Install dependencies
    && apk --no-cache add --update ${RUNTIME_DEPS} ${BUILD_DEPS} \
    && pip install --upgrade pip \
    #
    # Install additional components
    && export GOPATH=/go \
    && go get github.com/pritunl/pritunl-dns \
    && go get github.com/pritunl/pritunl-web \
    && cp /go/bin/* /usr/bin/ \
    #
    # Download and extract
    && curl -o pritunl.tar.gz -fSL ${PRITUNL_URL} \
    && echo "${PRITUNL_SHA1} *pritunl.tar.gz" | sha1sum -c - \
    && tar zxvf pritunl.tar.gz \
    && cd pritunl-${PRITUNL_VERSION} \
    #
    # Build
    && python setup.py build \
    && pip install -r requirements.txt \
    && python setup.py install \
    #
    # Clean up
    && apk del --purge $BUILD_DEPS \
    && rm -rf /tmp/* /var/cache/apk/* /go/*

COPY openssl.cnf /etc/ssl/openssl.cnf
COPY entrypoint.sh /bin/entrypoint.sh

EXPOSE 80 443 1194 1194/udp

ENTRYPOINT ["entrypoint.sh"]
CMD ["pritunl", "start"]
