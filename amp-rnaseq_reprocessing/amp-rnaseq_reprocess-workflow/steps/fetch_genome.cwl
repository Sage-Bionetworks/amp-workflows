#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
doc: Retrieve genome files for indexing.
label: Genome fetching tool.
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: fetch_genome.sh
        entry: |-
          #!/usr/bin/env bash

          wget -q -O $(inputs.annotation_gtf_filename).gz $(inputs.annotation_gtf_url)
          wget -q -O $(inputs.genome_fasta_filename).gz $(inputs.genome_fasta_url)
          gunzip *.gz

baseCommand: ["bash", "fetch_genome.sh"]

inputs:
  genome_fasta_url:
    type: string
  genome_fasta_filename:
    type: string
  annotation_gtf_url:
    type: string
  annotation_gtf_filename:
    type: string

outputs:
  - id: genome_fasta_file
    type: File
    outputBinding:
      glob: $(inputs.genome_fasta_filename)
  - id: annotation_gtf_file
    type: File
    outputBinding:
      glob: $(inputs.annotation_gtf_filename)

'dct:creator':
  '@id': 'http://orcid.org/0000-0002-4475-8396'
  'foaf:name': 'Tess Thyer'
  'foaf:mbox': 'mailto:tess.thyer@sagebionetworks.org'
