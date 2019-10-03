class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: sample_provenance
baseCommand: ["python", "provenance.py"]
inputs:
  - id: synapseconfig
    type: File
    inputBinding:
      position: 1
  - id: argurl
    type: string
    inputBinding:
      position: 2
outputs:
  - id: provenance_csv
    type: File
    outputBinding:
      glob: '*csv'
label: provenance.cwl
requirements:
  - class: DockerRequirement
    dockerFile: |
      FROM python:3

      RUN pip install synapseclient requests
    dockerImageId: amp-workflows/provenance
  - class: InitialWorkDirRequirement
    listing:
      - entryname: provenance.py
        entry: |-
          #!/usr/bin/env python

          import json
          import os
          import logging
          import requests
          import synapseclient as sc
          import sys

          from requests.adapters import HTTPAdapter
          from requests.packages.urllib3.util.retry import Retry

          # synapse config file
          synconf = sys.argv[1]
          #url to job.json file
          joburl = sys.argv[2]

          # Retrieve the data in the input job.json file
          s = requests.Session()
          retries = Retry(total=5, backoff_factor=1, status_forcelist=[ 502, 503, 504 ])
          s.mount('http://', HTTPAdapter(max_retries=retries))
          data = s.get(joburl).json()

          # Login to synapse using credentials in synapse config file
          syn = sc.Synapse(configPath=synconf)
          syn.login()

          # Print header of provenance file
          print('id' + ',' + 'versionNumber' + ',' +  'specimenID', file=open('provenance.csv', 'a'))

          # Iterate through input bam files and retrieve specimen ids and version numbers
          if 'synapseid' in data: # assume this is cwltool-style input
              synapseids = data.get('synapseid', [])
          elif 'args' in data: # assume this is tibanna-style input
              synapseids = data.get('args', {}).get('input_parameters', {}).get('synapseid', [])
          else:
              raise KeyError(f'"synapseid" not found in data downloaded from joburl={joburl}')

          for item in synapseids:
              version = (syn.get(item, downloadFile=False).versionNumber)
              annotations = syn.getAnnotations(item)
              if annotations:
                  specimen = annotations['specimenID'][0]
              else:
                  specimen = "NA"
              print(item + ',' + str(version) + ',' +  specimen, file=open('provenance.csv','a'))

          # Get list of synapse IDs in the genome folder and retrieve specimen ids and version numbers
          synlist = []
          if 'index_synapseid' in data:
              indexfolder = data['index_synapseid']
          elif 'args' in data:
              indexfolder = data.get('args', {}).get('input_parameters', {}).get('index_synapseid', '')
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
