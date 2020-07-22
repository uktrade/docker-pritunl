#!/usr/bin/env python3

from pymongo import MongoClient
import environ

env = environ.Env()
client = MongoClient(env('PRITUNL_DB'))
db = client.pritunl
hosts = db.hosts
servers = db.servers

hosts.delete_many({'status': 'offline'})
hosts.update_many({'status': 'online'}, {'$set': {'name': env('PRITUNL_HOST'), 'public_address': env('PRITUNL_DOMAIN')}})
new_hosts = hosts.find({'status': 'online'})
new_host_ids = []
for host in new_hosts:
    new_host_ids.append(host['_id'])

result = servers.update_many({}, {'$set': {'hosts': new_host_ids}})
print(result.modified_count)
