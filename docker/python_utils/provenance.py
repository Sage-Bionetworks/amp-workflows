#!/usr/bin/env python

import json
import synapseclient as sc
import sys

injson = sys.argv[1]
synconf = sys.argv[2]

print(synconf)

syn = sc.Synapse(configPath=synconf)
syn.login()

with open(injson) as json_file:
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

