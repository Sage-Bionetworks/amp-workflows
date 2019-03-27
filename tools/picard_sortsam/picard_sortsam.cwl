#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: picard_sortsam
label: Picard SortSam

doc: |
  Use Picard to sort a SAM or BAM file.

  Original command:
  java -Xmx8G -jar $PICARD SortSam \
    INPUT="${indir}/${1}" \
    OUTPUT=/dev/stdout \
    SORT_ORDER=queryname \
    QUIET=true \
    VALIDATION_STRINGENCY=SILENT \
    COMPRESSION_LEVEL=0

baseCommand: ['picard.sh', 'SortSam']

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

  - id: sort_order
    label: Sort order
    type: string
    default: "queryname"
    inputBinding:
      position: 2
      prefix: SORT_ORDER=
      separate: false

  - id: quiet
    label: Verbosity (QUIET)
    type: string
    default: "true"
    inputBinding:
      position: 3
      prefix: QUIET=
      separate: false

  - id: validation_stringency
    label: Validation stringency
    default: "SILENT"
    type: string
    inputBinding:
      position: 4
      prefix: VALIDATION_STRINGENCY=
      separate: false

  - id: compression_level
    label: Compression level
    default: 0
    type: int
    inputBinding:
      position: 4
      prefix: COMPRESSION_LEVEL=
      separate: false

  - id: sorted_reads_filename
    label: Sorted SAM filename
    type: string
    inputBinding:
      position: 5
      prefix: OUTPUT=
      separate: false

outputs:

  - id: sorted_reads_bam
    label: Sorted reads SAM
    doc: Sorted SAM (or BAM) file
    type: File
    outputBinding:
      glob: '*.bam'
