#!/usr/bin/env python
import os
import synapseclient as sc
import sys
import urllib.request

#The file to be uploaded to synapse
infile = sys.argv[1]
#The folder on synapse that will host the uploaded file
parentid = sys.argv[2]
#Synapse config file
synconf = sys.argv[3]
#URL for job args file
usedent = sys.argv[4]
#URL for workflow
wflink = sys.argv[5]

syn = sc.Synapse(configPath=synconf)
syn.login()

# Get the github url for the workflow
#wflink = os.getenv('WORKFLOW_URL')
#usedent = os.getenv('CWL_ARGS_URL')

file = sc.File(path=infile, parent=parentid)
print(file)
file = syn.store(file, executed=wflink,used=usedent)
results = {'uploadedFileId':file.id,'uploadedFileVersion':file.versionNumber}

print(results)
