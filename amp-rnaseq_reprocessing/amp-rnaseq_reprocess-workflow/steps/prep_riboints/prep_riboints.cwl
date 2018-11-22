#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: prep-riboints
label: Generate Picard ribosomal intervals file

doc: |
  Generate ribosomal intervals reference file for Picard CollectRnaSeqMetrics.

baseCommand: ['make_riboints.sh']

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

  - id: input_bam
    label: Input BAM
    doc: Input file in BAM format
    type: File
    inputBinding:
      position: 1

outputs:
  - id: output
    label: Output ribosomal interval list
    doc: Output ribosomal (rRNA) interval list file
    type: File
    outputBinding:
      glob: *.rRNA.interval_list
