class: Workflow
cwlVersion: v1.0
doc: |
  Align RNA-seq data for each sample using STAR.
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: aligned_reads_bam
    type: File
    'sbg:x': -484
    'sbg:y': -39
outputs:
  - id: output_gz
    outputSource:
      - zcat/output_gz
    type: File
    'sbg:x': 316
    'sbg:y': -36
steps:
  - id: picard_sortsam
    in:
      - id: aligned_reads_bam
        source: aligned_reads_bam
    out:
      - id: sorted_reads_bam
    run: steps/picard_sortsam.cwl
    label: Picard SortSam
    'sbg:x': -349
    'sbg:y': -40
  - id: picard_samtofastq
    in:
      - id: reads_bam
        source: picard_sortsam/sorted_reads_bam
    out:
      - id: output
    run: steps/picard_samtofastq.cwl
    label: Use Picard to convert BAM to FASTQ
    'sbg:x': -218
    'sbg:y': 64
  - id: gzip
    in:
      - id: input_file
        source: picard_samtofastq/output
    out:
      - id: output_gz
    run: steps/gzip.cwl
    'sbg:x': -86
    'sbg:y': -38
  - id: zcat
    in:
      - id: input_gzs
        source:
          - gzip/output_gz
    out:
      - id: output_gz
    run: steps/zcat.cwl
    'sbg:x': 138
    'sbg:y': -37
requirements: []
'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': James Eddy
