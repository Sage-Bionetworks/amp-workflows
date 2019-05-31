class: Workflow
cwlVersion: v1.0
id: main_paired
label: main-paired
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: genome_fastas
    type: File
    'sbg:x': -781.206298828125
    'sbg:y': -256.5
  - id: genemodel_gtf
    type: File
    'sbg:x': -795.1556396484375
    'sbg:y': -109.12567901611328
  - id: synapse_config
    type: File
    'sbg:x': -522.0704956054688
    'sbg:y': -348.93670654296875
  - id: synapseid
    type: string
    'sbg:x': -405
    'sbg:y': -412
outputs:
  - id: reads_per_gene
    outputSource:
      - wf_alignment/reads_per_gene
    type: File
    'sbg:x': -148
    'sbg:y': -351
  - id: realigned_reads_sam
    outputSource:
      - wf_alignment/realigned_reads_sam
    type: File
    'sbg:x': -178
    'sbg:y': -472
  - id: combined_metrics_csv
    outputSource:
      - wf_metrics/combined_metrics_csv
    type: File
    'sbg:x': 386.2437744140625
    'sbg:y': -182.75
steps:
  - id: wf_buildindexes
    in:
      - id: genome_fastas
        source: genome_fastas
      - id: genemodel_gtf
        source: genemodel_gtf
    out:
      - id: genome_dir
    run: ./wf-buildindexes.cwl
    label: Index building sub-workflow
    'sbg:x': -639.203125
    'sbg:y': -182.5
  - id: wf_alignment
    in:
      - id: genome_dir
        source: wf_buildindexes/genome_dir
      - id: synapse_config
        source: synapse_config
      - id: synapseid
        source: synapseid
    out:
      - id: splice_junctions
      - id: reads_per_gene
      - id: logs
      - id: realigned_reads_sam
    run: ./wf-alignment.cwl
    label: Alignment sub-workflow
    'sbg:x': -310.91680908203125
    'sbg:y': -200.39964294433594
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
    'sbg:x': -516
    'sbg:y': 12
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
    'sbg:x': 128
    'sbg:y': -185
requirements:
  - class: SubworkflowFeatureRequirement
