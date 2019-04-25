class: Workflow
cwlVersion: v1.0
label: Metrics sub-workflow
doc: |
  Align RNA-seq data for each sample using STAR.
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: genome_fasta
    type: File
    'sbg:x': -328
    'sbg:y': -270
  - id: aligned_reads_sam
    type: File
    'sbg:x': -340.39886474609375
    'sbg:y': 203
  - id: picard_refflat
    type: File
    'sbg:x': -350
    'sbg:y': 39
  - id: picard_riboints
    type: File
    'sbg:x': -347.39886474609375
    'sbg:y': -112
  - id: output_metrics_filename
    type: File
    'sbg:x': -400
    'sbg:y': -150
outputs:
  - id: combined_metrics_csv
    outputSource:
      - combine_metrics/combined_metrics_csv
    type: File
    'sbg:x': 378
    'sbg:y': -85
steps:
  - id: picard_rnaseqmetrics
    in:
      - id: aligned_reads_sam
        source: aligned_reads_sam
      - id: genome_fasta
        source: genome_fasta
      - id: picard_refflat
        source: picard_refflat
      - id: picard_riboints
        source: picard_riboints
      - id: output_metrics_filename
        source: output_metrics_filename
    out:
      - id: rnaseqmetrics_txt
    run: steps/picard_rnaseq_metrics.cwl
    label: Picard CollectRnaSeqMetrics
    'sbg:x': -71
    'sbg:y': -21
  - id: picard_alignmentsummarymetrics
    in:
      - id: aligned_reads_sam
        source: aligned_reads_sam
      - id: genome_fasta
        source: genome_fasta
    out:
      - id: alignmentsummarymetrics_txt
    run: steps/picard_alignmentsummary_metrics.cwl
    label: Picard CollectAlignmentSummaryMetrics module
    'sbg:x': -72
    'sbg:y': -251
  - id: combine_metrics
    in:
      - id: picard_metrics
        source:
          - picard_alignmentsummarymetrics/alignmentsummarymetrics_txt
          - picard_rnaseqmetrics/rnaseqmetrics_txt
    out:
      - id: combined_metrics_csv
    run: steps/combine_metrics_sample.cwl
    label: Combine Picard metrics per sample
    'sbg:x': 192.60113525390625
    'sbg:y': -121
requirements:
  - class: MultipleInputFeatureRequirement
'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': James Eddy
