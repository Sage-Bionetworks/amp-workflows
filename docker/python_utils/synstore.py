#!/usr/bin/env python
import synapseclient as sc
import sys

#The file to be uploaded to synapse
infile = sys.argv[1]
#The github link to the workflow code that was executed
wflink = sys.argv[2]
#The folder on synapse that will host the uploaded file
parentid = sys.argv[3]
#The input file that was run through the workflow
usedent = sys.argv[4]
#Synapse config file
synconf = sys.argv[5]

syn = sc.Synapse(configPath=synconf)
syn.login()

file = sc.File(path=infile, parent=parentid)
print(file)
file = syn.store(file, executed=wflink,used=usedent)
results = {'uploadedFileId':file.id,'uploadedFileVersion':file.versionNumber}

print(results)
