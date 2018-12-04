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
    label: Gene model GTF file
    doc: Gene annotations (gene model) in GTF format from Gencode
    type: File
    inputBinding:
      position: 0

  - id: reads_aligned_bam
    label: Input BAM file
    doc: Input file with aligned reads in BAM format
    type: File
    inputBinding:
      position: 1

outputs:

  - id: picard_riboints
    label: Output ribosomal interval list
    doc: Output ribosomal (rRNA) interval list file
    type: File
    outputBinding:
      glob: "*.rRNA.interval_list"
