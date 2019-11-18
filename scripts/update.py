#!/usr/bin/env python3

from pymongo import MongoClient
import environ

env = environ.Env()
client = MongoClient(env('PRITUNL_DB'))
db = client.pritunl
hosts = db.hosts
servers = db.servers

hosts.delete_many({'status': 'offline'})
hosts.update_many({'status': 'online'}, {'$set': {'name': env('PRITUNL_HOST')}})
host = hosts.find_one({'status': 'online'})
result = servers.update_many({}, {'$set': {'hosts': [host['_id']]}})
print(result.modified_count)
