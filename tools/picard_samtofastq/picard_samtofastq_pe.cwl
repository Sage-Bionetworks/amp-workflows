#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: picard-samtofastq
label: Use Picard to convert BAM to FASTQ

doc: |
  Use Picard to convert BAM to FASTQ.

  Original command:
  java -Xmx4G -jar $PICARD SamToFastq \
    INPUT=/dev/stdin \
    FASTQ="${fastqdir}/${sample}.r1.fastq" \
    SECOND_END_FASTQ="${fastqdir}/${sample}.r2.fastq" \
    VALIDATION_STRINGENCY=SILENT

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

  - id: reads_r1_fastq
    type: string
    inputBinding:
      position: 2
      prefix: FASTQ=
      separate: false

  - id: reads_r2_fastq
    type: string
    inputBinding:
      position: 3
      prefix: SECOND_END_FASTQ=
      separate: false

  - id: validation_stringency
    type: string
    inputBinding:
      position: 4
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  - id: output
    label: Output FASTQ
    doc: Output FASTQ file
    type: File
    outputBinding:
      glob: *.fastq
