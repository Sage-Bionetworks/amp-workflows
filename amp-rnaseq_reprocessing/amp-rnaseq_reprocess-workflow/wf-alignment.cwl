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
    'sbg:x': -459
    'sbg:y': 21
  - id: genome_dir
    type: Directory?
    'sbg:x': 273.41412353515625
    'sbg:y': 167.5
  - id: sorted_reads_filename
    type: string
    'sbg:x': -579
    'sbg:y': -41
  - id: reads_r1_fastq
    type: string
    'sbg:x': -427
    'sbg:y': 249
  - id: reads_r2_fastq
    type: string?
    'sbg:x': -271
    'sbg:y': 318
  - id: nthreads
    type: int
    'sbg:x': 418
    'sbg:y': 255
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
#  - id: output_fq
#    outputSource:
#      - picard_samtofastq/output_fq
#    type: File[]
#    'sbg:x': -11.111109733581543
#    'sbg:y': 229.41175842285156
steps:
  - id: picard_sortsam
    in:
      - id: aligned_reads_sam
        source: aligned_reads_sam
      - id: sorted_reads_filename
        source: sorted_reads_filename
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
      - id: reads_r1_fastq
        source: reads_r1_fastq
      - id: reads_r2_fastq
        source: reads_r2_fastq
    out:
      - id: mate_1
      - id: mate_2
    run: steps/picard_samtofastq.cwl
    label: Picard SamToFastq
    'sbg:x': -147
    'sbg:y': 116
  - id: star_align
    in:
#      - id: unaligned_reads_fastq
#        source:
#          - picard_samtofastq/output_fq

      - id: mate_1_fastq
        source: picard_samtofastq/mate_1
      - id: mate_2_fastq
        source: picard_samtofastq/mate_2
      - id: genome_dir
        source: genome_dir
      - id: nthreads
        source: nthreads
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
