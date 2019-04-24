class: Workflow
cwlVersion: v1.0
id: wf_alignment
doc: |
  Align RNA-seq data for each sample using STAR.
label: Alignment sub-workflow
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: aligned_reads_sam
    type: File
    'sbg:x': -451.2436218261719
    'sbg:y': -10
  - id: genome_dir
    type: Directory
    'sbg:x': 273.41412353515625
    'sbg:y': 167.5
outputs:
  - id: splice_junctions
    outputSource:
      - star_align/splice_junctions
    type: File
    'sbg:x': 592
    'sbg:y': -98
  - id: reads_per_gene
    outputSource:
      - star_align/reads_per_gene
    type: File
    'sbg:x': 664
    'sbg:y': 5
  - id: logs
    outputSource:
      - star_align/logs
    type: 'File[]'
    'sbg:x': 660
    'sbg:y': 150
  - id: realigned_reads_sam
    outputSource:
      - star_align/aligned_reads_sam
    type: File
    'sbg:x': 601
    'sbg:y': 247
steps:
  - id: picard_sortsam
    in:
      - id: aligned_reads_sam
        source: aligned_reads_sam
    out:
      - id: sorted_reads_bam
    run: steps/picard_sortsam.cwl
    label: Picard SortSam
    'sbg:x': -307
    'sbg:y': -10
  - id: picard_samtofastq
    in:
      - id: aligned_reads_sam
        source: picard_sortsam/sorted_reads_bam
    out:
      - id: output
    run: steps/picard_samtofastq.cwl
    label: Picard SamToFastq
    'sbg:x': -147
    'sbg:y': 116
  - id: gzip
    in:
      - id: input_file
        source: picard_samtofastq/output
    out:
      - id: output_gz
    run: steps/gzip.cwl
    'sbg:x': -28
    'sbg:y': -9
  - id: zcat
    in:
      - id: input_gzs
        source:
          - gzip/output_gz
    out:
      - id: output_gz
    run: steps/zcat.cwl
    'sbg:x': 165
    'sbg:y': -8
  - id: star_align
    in:
      - id: unaligned_reads_fastq
        source:
          - zcat/output_gz
      - id: genome_dir
        source: genome_dir
    out:
      - id: aligned_reads_sam
      - id: reads_per_gene
      - id: splice_junctions
      - id: logs
    run: steps/star_align.cwl
    label: STAR spliced alignment
    'sbg:x': 440
    'sbg:y': 58
requirements: []
'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': James Eddy
