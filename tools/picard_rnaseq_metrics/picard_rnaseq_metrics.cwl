#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: picard-rnaseqmetrics
label: Picard CollectRnaSeqMetrics module

doc: |
  Use Picard to compute alignment summary metrics.

  Original command:
  java -Xmx8G -jar $PICARD CollectRnaSeqMetrics \
    VALIDATION_STRINGENCY=LENIENT \
    MAX_RECORDS_IN_RAM=4000000 \
    STRAND_SPECIFICITY=NONE \
    MINIMUM_LENGTH=500 \
    RRNA_FRAGMENT_PERCENTAGE=0.8 \
    METRIC_ACCUMULATION_LEVEL=ALL_READS \
    R=$FASTA \
    REF_FLAT=$REFFLAT \
    RIBOSOMAL_INTERVALS=$RIBOINTS \
    INPUT="picard/${sample}.tmp.bam" \
    OUTPUT="picard/${sample}/picard.analysis.CollectRnaSeqMetrics" \
    TMP_DIR="${scratchdir}/${USER}/${sample}/"

baseCommand: ['picard.sh', 'CollectRnaSeqMetrics']

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/sage-bionetworks/picard_utils:1.0'

inputs:

  - id: reads_aligned_bam
    label: Input reads BAM
    doc: Input reads data file in BAM format
    type: File
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false

  - id: reference_genome_fasta
    type: File
    inputBinding:
      position: 2
      prefix: R=
      separate: false

  - id: reference_refflat
    type: File
    inputBinding:
      position: 3
      prefix: REF_FLAT=
      separate: false

  - id: reference_riboints
    type: File
    inputBinding:
      position: 4
      prefix: RIBOSOMAL_INTERVALS=
      separate: false

  - id: max_records_in_ram
    type: int
    inputBinding:
      position: 5
      prefix: MAX_RECORDS_IN_RAM=
      separate: false

  - id: strand_specificity
    type: string
    inputBinding:
      position: 6
      prefix: STRAND_SPECIFICITY=
      separate: false

  - id: minimum_length
    type: int
    inputBinding:
      position: 7
      prefix: MINIMUM_LENGTH=
      separate: false

  - id: rrna_fragment_percentage
    type: float
    inputBinding:
      position: 8
      prefix: RRNA_FRAGMENT_PERCENTAGE=
      separate: false

  - id: metric_accumulation_level
    type: string
    inputBinding:
      position: 9
      prefix: METRIC_ACCUMULATION_LEVEL=
      separate: false

  - id: validation_stringency
    type: string
    inputBinding:
      position: 10
      prefix: VALIDATION_STRINGENCY=
      separate: false

  - id: output_metrics
    type: string
    inputBinding:
      position: 11
      prefix: OUTPUT=
      separate: false

outputs:

  - id: rnaseqmetrics_txt
    label: Output metrics
    doc: Output metrics file
    type: File
    outputBinding:
      glob: "*.CollectRnaSeqMetrics"
