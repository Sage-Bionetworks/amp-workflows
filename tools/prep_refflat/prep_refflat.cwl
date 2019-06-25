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
    dockerPull: 'wpoehlm/ngstools:picard'

inputs:

  - id: genemodel_gtf
    label: Gene model GTF
    doc: Gene annotations (gene model) in GTF from Gencode
    type: File
    inputBinding:
      position: 0

outputs:

  - id: picard_refflat
    label: Picard refFlat
    doc: Picard refFlat reference
    type: File
    outputBinding:
      glob: "*.refFlat.txt"
