class: Workflow
cwlVersion: v1.0
id: main_paired
label: main-paired
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: index_synapseid
    type: string
  - id: synapse_config
    type: File
    'sbg:x': -522.0704956054688
    'sbg:y': -348.93670654296875
  - id: synapseid
    type: 'string[]'
    'sbg:x': -405
    'sbg:y': -412
  - id: nthreads
    type: int
    'sbg:x': -422
    'sbg:y': -411
  - id: genstr
    type: string?
  - id: output_metrics_filename
    type: string?
outputs:
  - id: realigned_reads_sam
    outputSource:
      - wf_alignment/realigned_reads_sam
    type: 'File[]'
    'sbg:x': -178
    'sbg:y': -472
  - id: combined_counts
    outputSource:
      - combine_counts/combined_counts
    type: File
    'sbg:x': 57.103759765625
    'sbg:y': 47.5
  - id: combined_metrics
    outputSource:
      - combine_metrics/combined_metrics
    type: File
    'sbg:x': 550
    'sbg:y': -160
  - id: starlog_merged
    outputSource:
      - merge_starlog/starlog_merged
    type: File
    'sbg:x': 50.2137451171875
    'sbg:y': 299.5
steps:
  - id: wf_getindexes
    in:
      - id: synapseid
        source: index_synapseid
      - id: synapse_config
        source: synapse_config
    out:
      - id: files
      - id: genome_fasta
      - id: genemodel_gtf
    run: ./wf-getindexes.cwl
    label: Get index files
  - id: wf_alignment
    in:
      - id: genome_dir
        source: wf_getindexes/files
      - id: genstr
        source: genstr
      - id: nthreads
        source: nthreads
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
    scatter:
      - synapseid
    scatterMethod: dotproduct
    'sbg:x': -310.91680908203125
    'sbg:y': -200.39964294433594
  - id: wf_buildrefs
    in:
      - id: genemodel_gtf
        source: wf_getindexes/genemodel_gtf
      - id: aligned_reads_sam
        source: wf_alignment/realigned_reads_sam
        valueFrom: $(self[0])
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
        source: wf_getindexes/genome_fasta
      - id: aligned_reads_sam
        source: wf_alignment/realigned_reads_sam
      - id: picard_refflat
        source: wf_buildrefs/picard_refflat
      - id: picard_riboints
        source: wf_buildrefs/picard_riboints
      - id: basef
        source: synapseid
      - id: output_metrics_filename
        source: output_metrics_filename
    out:
      - id: combined_metrics_csv
    run: ./wf-metrics.cwl
    label: Metrics sub-workflow
    scatter:
      - aligned_reads_sam
      - basef
    scatterMethod: dotproduct
    'sbg:x': 128
    'sbg:y': -185
  - id: combine_counts
    in:
      - id: read_counts
        source:
          - wf_alignment/reads_per_gene
    out:
      - id: combined_counts
    run: steps/combine_counts_study.cwl
    label: Combine read counts across samples
    'sbg:x': -63.8984375
    'sbg:y': 31.5
  - id: combine_metrics
    in:
      - id: picard_metrics
        source:
          - wf_metrics/combined_metrics_csv
    out:
      - id: combined_metrics
    run: steps/combine_metrics_study.cwl
    label: Combine Picard metrics across samples
    'sbg:x': 343.8936767578125
    'sbg:y': -158.5
  - id: merge_starlog
    in:
      - id: logs
        source:
          - wf_alignment/logs
    out:
      - id: starlog_merged
    run: steps/merge_starlog.cwl
    label: merge_starlog
    'sbg:x': -132.7860107421875
    'sbg:y': 294.5
requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
