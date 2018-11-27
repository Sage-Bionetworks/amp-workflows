#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: picard-samtofastq
label: Use Picard to convert BAM to FASTQ

doc: |
  Use Picard to convert BAM to FASTQ.

  Original command:
  java -Xmx8G -jar $PICARD SortSam \
    INPUT="${indir}/${1}" \
    OUTPUT=/dev/stdout \
    SORT_ORDER=queryname \
    QUIET=true \
    VALIDATION_STRINGENCY=SILENT \
    COMPRESSION_LEVEL=0

baseCommand: ['SortSam']

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/Sage-Bionetworks/picard_utils:1.0'

inputs:
  - id: reads_bam
    label: Input reads BAM
    doc: Input reads data file in BAM format
    type: File
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false

  - id: sort_order
    type: string
    inputBinding:
      position: 2
      prefix: SORT_ORDER=
      separate: false

  - id: quiet
    type: string
    inputBinding:
      position: 3
      prefix: QUIET=
      separate: false

  - id: validation_stringency
    type: string
    inputBinding:
      position: 4
      prefix: VALIDATION_STRINGENCY=
      separate: false

  - id: compression_level
    type: string
    inputBinding:
      position: 4
      prefix: COMPRESSION_LEVEL=
      separate: false

outputs:
  - id: output
    label: Output FASTQ
    doc: Output FASTQ file
    type: File
    outputBinding:
      glob: *.fastq
