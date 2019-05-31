#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: combine-metrics
label: Combine Picard metrics per sample

doc: |
  Combine data from one or more Picard metrics outputs into a
  single CSV table.

baseCommand: ['combine_metrics_sample.py']

requirements:
  StepInputExpressionRequirement: {}

hints:
  - class: DockerRequirement
    dockerPull: 'wpoehlm/ngstools:picard'

inputs:
  - id: basef
    type: string
  - id: picard_metrics
    label: Picard metrics files to combine
    type: File[]
    inputBinding:
      position: 0

  - id: combined_metrics_filename
    label: Output metrics filename
    type: string
    inputBinding:
      position: 1
      prefix: -o

outputs:

  - id: combined_metrics_csv
    label: Combined metrics table
    doc: Combined metrics table saved as CSV text file
    type: File
    outputBinding:
      glob: "*csv"
