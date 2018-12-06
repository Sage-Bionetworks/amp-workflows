#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: picard-alignmentsummarymetrics
label: Picard CollectAlignmentSummaryMetrics module

doc: |
  Use Picard to compute alignment summary metrics.

  Original command:
  java -Xmx8G -jar $PICARD CollectAlignmentSummaryMetrics \
    VALIDATION_STRINGENCY=LENIENT \
    MAX_RECORDS_IN_RAM=4000000 \
    ASSUME_SORTED=true \
    ADAPTER_SEQUENCE= \
    IS_BISULFITE_SEQUENCED=false \
    MAX_INSERT_SIZE=100000 \
    R=$FASTA \
    INPUT="picard/${sample}.tmp.bam" \
    OUTPUT="picard/${sample}/picard.analysis.CollectAlignmentSummaryMetrics" \
    TMP_DIR="${scratchdir}/${USER}/${sample}/"

baseCommand: ['picard.sh', 'CollectAlignmentSummaryMetrics']

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/sage-bionetworks/picard_utils:1.0'

inputs:

  - id: aligned_reads_sam
    label: Aligned reads SAM
    doc: Reads data file in SAM (or BAM) format
    type: File
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false

  - id: genome_fasta
    label: Genome sequence FASTA
    doc: Reference genome sequence in FASTA format
    type: File
    inputBinding:
      position: 2
      prefix: R=
      separate: false

  - id: max_insert_size
    type: int
    inputBinding:
      position: 3
      prefix: MAX_INSERT_SIZE=
      separate: false

  - id: max_records_in_ram
    type: int
    inputBinding:
      position: 4
      prefix: MAX_RECORDS_IN_RAM=
      separate: false

  - id: assume_sorted
    type: string
    inputBinding:
      position: 5
      prefix: ASSUME_SORTED=
      separate: false

  - id: is_bisulfite_seq
    type: string
    inputBinding:
      position: 6
      prefix: IS_BISULFITE_SEQUENCED=
      separate: false

  - id: adapter_sequence
    type: string
    inputBinding:
      position: 7
      prefix: ADAPTER_SEQUENCE=
      separate: false

  - id: validation_stringency
    type: string
    inputBinding:
      position: 8
      prefix: VALIDATION_STRINGENCY=
      separate: false

  - id: output_metrics_filename
    type: string
    inputBinding:
      position: 9
      prefix: OUTPUT=
      separate: false

outputs:

  - id: alignmentsummarymetrics_txt
    label: Picard AlignmentSummaryMetrics
    doc: Picard CollectAlignmentSummaryMetrics results
    type: File
    outputBinding:
      glob: "*.CollectAlignmentSummaryMetrics"
