#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: picard-samtofastq
label: Picard SamToFastq

doc: |
  Use Picard to convert BAM to FASTQ.

  Original command:
  java -Xmx4G -jar $PICARD SamToFastq \
    INPUT=/dev/stdin \
    FASTQ="${fastqdir}/${sample}.r1.fastq" \
    SECOND_END_FASTQ="${fastqdir}/${sample}.r2.fastq" \
    VALIDATION_STRINGENCY=SILENT

baseCommand: ['picard.sh', 'SamToFastq']

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: 'wpoehlm/ngstools:picard'

inputs:

  - id: aligned_reads_sam
    label: Aligned reads SAM
    doc: Reads data file in SAM (or BAM) format
    type: File
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false

  - id: reads_r1_fastq
    label: R1 reads FASTQ
    type: string
    inputBinding:
      position: 2
      prefix: FASTQ=
      separate: false

  - id: reads_r2_fastq
    label: R2 reads FASTQ
    type: string?
    inputBinding:
      position: 3
      prefix: SECOND_END_FASTQ=
      separate: false

  - id: validation_stringency
    type: string
    default: "LENIENT"
    inputBinding:
      position: 4
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
#  - id: output_fq
#    label: fastq
#    type: File[]
#    outputBinding:
#      glob: "*fastq"

  - id: mate_1
    label: mate 1 fastq
    type: File
    outputBinding:
      glob: "*_1.fastq"

  - id: mate_2
    label: mate 2 fastq
    type: File
    outputBinding:
      glob: "*_2.fastq"


