#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: picard-rnaseqmetrics
label: Picard CollectRnaSeqMetrics

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

  - id: genome_fasta
    label: Genome sequence FASTA
    doc: Reference genome sequence in FASTA format
    type: File
    inputBinding:
      position: 2
      prefix: R=
      separate: false

  - id: picard_refflat
    label: Picard refFlat
    doc: Picard refFlat reference
    type: File
    inputBinding:
      position: 3
      prefix: REF_FLAT=
      separate: false

  - id: picard_riboints
    label: Picard ribosomal intervals
    doc: Picard ribosomal (rRNA) interval list file
    type: File
    inputBinding:
      position: 4
      prefix: RIBOSOMAL_INTERVALS=
      separate: false

  - id: max_records_in_ram
    type: int
    default: 4000000
    inputBinding:
      position: 5
      prefix: MAX_RECORDS_IN_RAM=
      separate: false

  - id: strand_specificity
    type: string
    default: "NONE"
    inputBinding:
      position: 6
      prefix: STRAND_SPECIFICITY=
      separate: false

  - id: minimum_length
    type: int
    default: 500
    inputBinding:
      position: 7
      prefix: MINIMUM_LENGTH=
      separate: false

  - id: rrna_fragment_percentage
    type: float
    default: 0.8
    inputBinding:
      position: 8
      prefix: RRNA_FRAGMENT_PERCENTAGE=
      separate: false

  - id: metric_accumulation_level
    type: string
    default: "ALL_READS"
    inputBinding:
      position: 9
      prefix: METRIC_ACCUMULATION_LEVEL=
      separate: false

  - id: validation_stringency
    type: string
    default: "LENIENT"
    inputBinding:
      position: 10
      prefix: VALIDATION_STRINGENCY=
      separate: false

  - id: output_metrics_filename
    type: string
    inputBinding:
      position: 11
      prefix: OUTPUT=
      separate: false

outputs:

  - id: rnaseqmetrics_txt
    label: Picard RnaSeqMetrics
    doc: Picard CollectRnaSeqMetrics results
    type: File
    outputBinding:
      glob: "*.CollectRnaSeqMetrics"
