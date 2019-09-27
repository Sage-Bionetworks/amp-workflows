#!/usr/bin/env python

import json
import os
import synapseclient as sc
import sys
import urllib.request

# synapse config file
synconf = sys.argv[1]
#url to job.json file
joburl = sys.argv[2]

# Get the github url to the job.json file
#joburl = os.getenv('CWL_ARGS_URL')

#download the job.json file
urllib.request.urlretrieve(joburl, 'job.json')


syn = sc.Synapse(configPath=synconf)
syn.login()

with open('job.json') as json_file:
    data = json.load(json_file)

print('id' + ',' + 'versionNumber' + ',' +  'specimenID', file=open('provenance.csv', 'a'))

for item in data['synapseid']:
    version = (syn.get(item, downloadFile=False).versionNumber)
    annotations = syn.getAnnotations(item)
    if annotations:
        specimen = annotations['specimenID'][0]
    else:
        specimen = "NA"
    print(item + ',' + str(version) + ',' +  specimen, file=open('provenance.csv','a'))


# Get list of synapse IDs in the genome folder
synlist = []
indexfolder = data['index_synapseid']
reffiles = syn.getChildren(parent=indexfolder, includeTypes=['file'])
for item in reffiles:
    synlist.append(item['id'])


for item in synlist:
    version = (syn.get(item, downloadFile=False).versionNumber)
    annotations = syn.getAnnotations(item)
    if annotations:
        specimen = annotations['specimenID'][0]
    else:
        specimen = "NA"
    print(item + ',' + str(version) + ',' +  specimen, file=open('provenance.csv','a'))

