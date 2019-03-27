#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: combine-metrics
label: Combine Picard metrics across samples

doc: |
  Combine individual sample metric files into a sample x metric matrix file.

baseCommand: ['combine_metrics_study.R']

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: 'wpoehlm/ngstools:picard'

arguments:

  - prefix: --out_dir
    valueFrom: $(runtime.outdir)

inputs:

  - id: picard_metrics
    label: Picard metrics files to combine
    type: File[]
    inputBinding:
      position: 0

  - id: output_prefix
    label: Output counts file prefix
    doc: |
      Prefix for output file (i.e., <prefix>_all_metrics_matrix.txt)).
    type: string
    inputBinding:
      position: 1
      prefix: --out_prefix

  - id: sample_suffix
    label: Suffix to remove from filename
    doc: |
      Suffix to strip from sample filename [default %(default)s].
    type: string
    default: "_picard.CombinedMetrics.csv"
    inputBinding:
      position: 2
      prefix: --sample_suffix

outputs:

  - id: combined_metrics
    label: Combined metrics matrix
    doc: Output combined metrics matrix saved as tab-delimited text file.
    type: File
    outputBinding:
      glob: "*_all_metrics_matrix.txt"
