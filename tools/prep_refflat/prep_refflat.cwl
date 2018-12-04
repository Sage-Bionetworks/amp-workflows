#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: prep-refflat
label: Build Picard refFlat

doc: |
  Generate refFlat reference file for Picard CollectRnaSeqMetrics.

baseCommand: ['make_refflat.sh']

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/sage-bionetworks/picard_utils:1.0'

inputs:

  - id: genemodel_gtf
    label: Gene model GTF file
    doc: Gene annotations (gene model) in GTF from Gencode
    type: File
    inputBinding:
      position: 0

outputs:

  - id: picard_refflat
    label: Output refFlat file
    doc: Output refFlat reference file
    type: File
    outputBinding:
      glob: "*.refFlat.txt"
