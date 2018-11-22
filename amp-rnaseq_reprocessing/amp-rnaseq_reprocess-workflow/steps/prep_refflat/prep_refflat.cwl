#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: prep-refflat
label: Generate Picard refFlat file

doc: |
  Generate refFlat reference file for Picard CollectRnaSeqMetrics.

baseCommand: ['make_refflat.sh']

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/Sage-Bionetworks/picard_utils:1.0'

inputs:
  - id: input_gtf
    label: Gene model GTF
    doc: Gene annotations (gene model) in GTF from Gencode
    type: File
    inputBinding:
      position: 0

outputs:
  - id: output
    label: Output refFlat
    doc: Output refFlat reference file
    type: File
    outputBinding:
      glob: *.refFlat.txt
