class: Workflow
cwlVersion: v1.0
label: AMP-AD RNA-seq Reprocessing
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
  - id: genome_fastas
    type: 'File[]'
    'sbg:x': -176
    'sbg:y': -256
  - id: genemodel_gtf
    type: File
    'sbg:x': -180.48533630371094
    'sbg:y': -87.0548095703125
  - id: output_prefix
    type: string
    'sbg:exposed': true
  - id: sample_suffix
    type: string
    'sbg:exposed': true
outputs:
  - id: combined_counts
    outputSource:
      - combine_counts/combined_counts
    type: File
    'sbg:x': 617.0514526367188
    'sbg:y': 105.48322296142578
  - id: combined_metrics
    outputSource:
      - combine_metrics/combined_metrics
    type: File
    'sbg:x': 1090.5570068359375
    'sbg:y': -31.02013397216797
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
  - id: combine_counts
    in:
      - id: read_counts
        source:
          - wf_alignment/reads_per_gene
    out:
      - id: combined_counts
    run: steps/combine_counts_study.cwl
    label: Combine read counts across samples
    'sbg:x': 403.40728759765625
    'sbg:y': 143.3702392578125
  - id: combine_metrics
    in:
      - id: picard_metrics
        source:
          - wf_metrics/combined_metrics_csv
      - id: output_prefix
        source: output_prefix
      - id: sample_suffix
        source: sample_suffix
    out:
      - id: combined_metrics
    run: steps/combine_metrics_study.cwl
    label: Combine Picard metrics across samples
    'sbg:x': 881.3758544921875
    'sbg:y': -99.6040267944336
requirements:
  - class: SubworkflowFeatureRequirement
'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': James Eddy
