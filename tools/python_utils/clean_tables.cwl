class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: clean_tables
inputs:
  - id: raw_tables
    type: File[]
    inputBinding:
      position: 1
outputs:
  - id: clean_counts
    type: File
    outputBinding:
      glob: 'gene_counts_clean.txt'
  - id: clean_log
    type: File
    outputBinding:
      glob: 'star_log_specimenid.txt'
  - id: clean_metrics
    type: File
    outputBinding:
      glob: 'sample_metrics_clean.txt'
label: clean_tables.cwl
arguments: ['python3', 'clean_tables.py']
hints:
  - class: DockerRequirement
    dockerPull: sagebionetworks/synapsepythonclient:v1.9.2
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.raw_tables)
      - entryname: clean_tables.py
        entry: |-
          #!/usr/bin/env python

          import os
          import pandas as pd
          import shutil

          """Convert Synids

          This script converts synapse ids into specimen ids for output files
          from the AMP-AD RNASeq reprocessing workflow.  The script also removes
          duplicate samples from the tables and write a set of "clean" tables
          """

          def parse_samples(prov):
              """Create dictionary from provenance.csv {synid:specimenid}"""
              count = 0
              sampledict = {}
              for line in open(prov):
                  count += 1
                  if count > 1:
                      syn = line.split(',')[0].strip()
                      spec = line.split(',')[2].strip()
                      if syn not in sampledict and spec != 'NA':
                          sampledict[syn] = spec
              return sampledict

          def update_count_header(sampledict, counttable):
              """Convert synapseid to specimen ID in header of count table"""
              from_file = open(counttable) 
              line = from_file.readline().strip()

              # convert the synapsee IDs to specimen IDs
              header = line.split('\t')
              header.pop(0)
              converted = []
              for item in header:
                  converted.append(sampledict[item])
              # Add the "feature" label to first field in the converted list
              converted.insert(0,"feature")
              # replace original header with converted header
              sep = '\t'
              to_file = open('gene_counts_specimenid.txt',mode='w')
              to_file.write(sep.join(converted) + '\n')
              shutil.copyfileobj(from_file, to_file)

              # Remove duplicate samples
              df = pd.read_csv('gene_counts_specimenid.txt', sep='\t', index_col='feature')
              df_clean = df.astype(int).fillna(0).T.drop_duplicates().T
              df_clean.to_csv(path_or_buf='gene_counts_clean.txt', sep='\t')

          def update_log_header(sampledict, logfile):
              """convert synapseid to specimenid in first column of star log table"""
              count = 0
              for line in open(logfile):
                  line = line.strip()
                  count += 1
                  if count == 1:
                      print(line, file=open('star_log_specimenid.txt','w'))
                  else:
                      syn = line.split('\t')[0]
                      content = line.split('\t')[1:]
                      specimen = sampledict[syn]
                      sep = '\t'
                      print(str(specimen + sep) + sep.join(content), file=open('star_log_specimenid.txt', 'a'))

              # remove duplicate samples
              df = pd.read_csv('star_log_specimenid.txt', sep='\t', index_col='Sample')
              # Since this table contains computational runtimes and mapping speeds, use only a subset of fields to idenify duplicates
              df_clean = df.drop_duplicates(subset=['Number of input reads', 'Uniquely mapped reads number'])
              df_clean.to_csv(path_or_buf='star_log_clean.txt',sep='\t')

          def update_metrics_header(sampledict, metrics):
              """convert synapseid to specimenid in headerof picard metrics file"""
              count = 0
              for line in open(metrics):
                  line = line.strip()
                  count += 1
                  if count == 1:
                      print(line, file=open('sample_metrics_specimenid.txt','w'))
                  else:
                      syn = line.split('\t')[0]
                      content = line.split('\t')[1:]
                      specimen = sampledict[syn]
                      sep = '\t'
                      print(str(specimen + sep) + sep.join(content), file=open('sample_metrics_specimenid.txt', 'a'))

              # Remove duplicate samples
              df = pd.read_csv('sample_metrics_specimenid.txt', sep='\t', index_col='sample')
              df_clean = df.drop_duplicates()
              df_clean.to_csv(path_or_buf='sample_metrics_clean.txt',sep='\t')

          def main():
              # create synapseid:sampleid dictionary
              sampledict = parse_samples('provenance.csv')

              # execute functions to convert headers and save new files
              update_count_header(sampledict, 'gene_all_counts_matrix.txt')
              update_log_header(sampledict, 'Star_Log_Merged.txt')
              update_metrics_header(sampledict, 'Study_all_metrics_matrix.txt')

          main()


