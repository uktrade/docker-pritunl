#!/usr/bin/env ruby

require 'pritunl_api_client'

@pritunl = PritunlApiClient::Client.new(
  base_url: ENV['PRITUNL_API'],
  api_token: ENV['PRITUNL_API_TOKEN'],
  api_secret: ENV['PRITUNL_API_SECRET'],
  verify_ssl: false
)

@pritunl.server.all.each { |it|
  @pritunl.server.stop(it['id'])
  @pritunl.server.start(it['id'])
}
