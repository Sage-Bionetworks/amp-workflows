#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: prep-riboints
label: Build Picard ribosomal intervals

doc: |
  Generate ribosomal intervals reference file for Picard CollectRnaSeqMetrics.

baseCommand: ['make_riboints.sh']

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/sage-bionetworks/picard_utils:1.0'

inputs:

  - id: genemodel_gtf
    label: Gene model GTF
    doc: Gene annotations (gene model) in GTF format from Gencode
    type: File
    inputBinding:
      position: 0

  - id: aligned_reads_sam
    label: Aligned reads SAM
    doc: Reads data file in SAM (or BAM) format
    type: File
    inputBinding:
      position: 1

outputs:

  - id: picard_riboints
    label: Picard ribosomal intervals
    doc: Picard ribosomal (rRNA) interval list file
    type: File
    outputBinding:
      glob: "*.rRNA.interval_list"
