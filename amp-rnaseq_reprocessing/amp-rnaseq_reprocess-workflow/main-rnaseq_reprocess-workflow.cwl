class: Workflow
cwlVersion: v1.0
doc: |
  Align RNA-seq data for each sample using STAR.
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: aligned_reads_sam
    type: File
    'sbg:x': 4.24212646484375
    'sbg:y': 41.5
  - id: output_directory
    type: Directory
    'sbg:x': 793.7315673828125
    'sbg:y': 43.118568420410156
  - id: genome_fastas
    type: 'File[]'
    'sbg:x': -172.6553497314453
    'sbg:y': -251.48434448242188
  - id: genemodel_gtf
    type: File
    'sbg:x': -180.48533630371094
    'sbg:y': -87.0548095703125
outputs: []
steps:
  - id: wf_alignment
    in:
      - id: aligned_reads_sam
        source: aligned_reads_sam
      - id: genome_dir
        source: wf_buildindexes/genome_dir
    out:
      - id: splice_junctions
      - id: reads_per_gene
      - id: logs
      - id: realigned_reads_sam
    run: ./wf-alignment.cwl
    label: Alignment sub-workflow
    'sbg:x': 179
    'sbg:y': -38
  - id: wf_buildrefs
    in:
      - id: genemodel_gtf
        source: genemodel_gtf
      - id: aligned_reads_sam
        source: wf_alignment/realigned_reads_sam
    out:
      - id: picard_riboints
      - id: picard_refflat
    run: ./wf-buildrefs.cwl
    label: Reference building sub-workflow
    'sbg:x': 406
    'sbg:y': -172
  - id: wf_metrics
    in:
      - id: genome_fasta
        source: genome_fastas
      - id: aligned_reads_sam
        source: wf_alignment/realigned_reads_sam
      - id: picard_refflat
        source: wf_buildrefs/picard_refflat
      - id: picard_riboints
        source: wf_buildrefs/picard_riboints
    out:
      - id: combined_metrics_csv
    run: ./wf-metrics.cwl
    label: Metrics sub-workflow
    'sbg:x': 659
    'sbg:y': -34
  - id: combine_metrics
    in:
      - id: picard_metrics
        source:
          - wf_metrics/combined_metrics_csv
      - id: output_directory
        source: output_directory
    out:
      - id: combined_metrics
    run: steps/combine_metrics_study.cwl
    label: Combine Picard metrics across samples
    'sbg:x': 935.9485473632812
    'sbg:y': -86.07830047607422
  - id: wf_buildindexes
    in:
      - id: genome_fastas
        source:
          - genome_fastas
      - id: genemodel_gtf
        source: genemodel_gtf
    out:
      - id: genome_dir
    run: ./wf-buildindexes.cwl
    label: Index building sub-workflow
    'sbg:x': 2.000000476837158
    'sbg:y': -180.13870239257812
requirements:
  - class: SubworkflowFeatureRequirement
'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': James Eddy
