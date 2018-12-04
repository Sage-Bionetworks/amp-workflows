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
    'sbg:x': -253.28173828125
    'sbg:y': -30
  - id: reads_aligned_bam
    type: File
    'sbg:x': -261.28173828125
    'sbg:y': 165
outputs:
  - id: picard_riboints
    outputSource:
      - prep_riboints/picard_riboints
    type: File
    'sbg:x': 176.71826171875
    'sbg:y': 183
  - id: picard_refflat
    outputSource:
      - prep_refflat/picard_refflat
    type: File
    'sbg:x': 164.71826171875
    'sbg:y': -24
steps:
  - id: prep_refflat
    in:
      - id: genemodel_gtf
        source: genemodel_gtf
    out:
      - id: picard_refflat
    run: steps/prep_refflat.cwl
    label: Build Picard refFlat
    'sbg:x': -33
    'sbg:y': -29
  - id: prep_riboints
    in:
      - id: genemodel_gtf
        source: genemodel_gtf
      - id: reads_aligned_bam
        source: reads_aligned_bam
    out:
      - id: picard_riboints
    run: steps/prep_riboints.cwl
    label: Build Picard ribosomal intervals
    'sbg:x': -35
    'sbg:y': 183
requirements: []
'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': James Eddy
