FROM ruby:stretch

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install pymongo django-environ
RUN gem install pritunl_api_client

ENV PRITUNL_DB mongodb://localhost:27017
ENV PRITUNL_HOST vpn
ENV PRITUNL_API https://localhost
ENV PRITUNL_API_TOKEN null
ENV PRITUNL_API_SECRET null

COPY update.py /
COPY restart.rb /
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
