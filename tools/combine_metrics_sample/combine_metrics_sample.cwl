#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: combine-metrics
label: Combine Picard metrics of different types for a sample.

doc: |
  Combine data from one or more Picard metrics outputs into a
  single CSV table.

baseCommand: ['combine_metrics_study.py']

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/Sage-Bionetworks/picard_utils:1.0'

inputs:

  - id: picard_metrics
    label: Picard metrics files to combine
    type: File[]
    inputBinding:
      position: 0

# sample_short=$(echo ${sample} | sed 's/\.accepted.*//' | sed 's/Aligned.out//')

outputs:

  - id: combined_metrics
    label: ...
    doc: ...
    type: File
    outputBinding:
      glob: "*_picard.CombinedMetrics.csv"
