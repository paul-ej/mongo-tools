import pymongo
from pymongo import MongoClient
import mongoengine
import yaml

### Local development only
# These components are intended for local development only.
# In the real world, store your credentials in vault, such as Azure Key Vault, AWS Secrets Manager etc.
# Locally, store these in something like KeePass with pykeepass to query the credentials from there
# REPEAT: This is just an example!
### End of notes


root_credentials = yaml.load("vars.yml", yaml.FullLoader)

client = MongoClient('127.0.0.1', 27017, username=root_credentials['username'], password=root_credentials['password'] )

user_credentials = yaml.load("vars.yml", yaml.FullLoader)

print(f'Adding User: {user_credentials["database"]["username"]}')

result = db.command({'createUser': user_credentials['database']['username'],
                     'pwd': user_credentials['database']['password'],
                     'roles': [{'role': 'readWrite', 'db': user_credentials['database']['database']}]
                     })

print(f'createUser result: {result}')