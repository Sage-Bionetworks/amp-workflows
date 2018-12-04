class: Workflow
cwlVersion: v1.0
doc: |
  Align RNA-seq data for each sample using STAR.
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: genemodel_gtf
    type: File
    'sbg:x': -197
    'sbg:y': -79
  - id: genomeFastaFiles
    type: 'File[]'
    'sbg:x': -197
    'sbg:y': 210
outputs:
  - id: starIndex
    outputSource:
      - star_index_1/starIndex
    type: 'File[]'
    'sbg:x': 171.4945526123047
    'sbg:y': 68.5
steps:
  - id: star_index_1
    in:
      - id: genomeFastaFiles
        source:
          - genomeFastaFiles
      - id: sjdbGTFfile
        source: genemodel_gtf
    out:
      - id: starIndex
    run: steps/star_index.cwl
    label: STAR genomeGenerate
    'sbg:x': -13
    'sbg:y': 67
requirements: []
'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': James Eddy
