class: Workflow
cwlVersion: v1.0
doc: |
  Build genome and transcriptome indexes for alignment, quantification.
label: Index building sub-workflow
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: genome_fastas
    type: 'File[]'
    'sbg:x': -682.5869140625
    'sbg:y': -429
  - id: genemodel_gtf
    type: File
    'sbg:x': -690.5869140625
    'sbg:y': -266
outputs:
  - id: genome_dir
    outputSource:
      - star_index/genome_dir
    type: Directory
    'sbg:x': -335.5869140625
    'sbg:y': -355
steps:
  - id: star_index
    in:
      - id: genome_fastas
        source:
          - genome_fastas
      - id: genemodel_gtf
        source: genemodel_gtf
    out:
      - id: genome_dir
    run: steps/star_index.cwl
    label: STAR genomeGenerate
    'sbg:x': -519
    'sbg:y': -354
requirements: []
'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': James Eddy
