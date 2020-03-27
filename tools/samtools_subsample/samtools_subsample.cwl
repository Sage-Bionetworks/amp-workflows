#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: samtools-subsample
label: samtools subsample tool

doc: |
  This tool uses samtools 'view' to subsample an input BAM file to a fraction
  of reads or read pairs.

  From samtools docs:

  Output only a proportion of the input alignments. This subsampling acts
  in the same way on all of the alignment records in the same template or
  read pair, so it never keeps a read but not its mate.

  When subsampling data that has previously been subsampled, be sure to use
  a different seed value from those used previously; otherwise more reads
  will be retained than expected.

baseCommand: ['samtools', 'view', '-bs']

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/samtools:1.9--h8ee4bcc_1'

inputs:
  - id: seed_fraction
    label: Subsample parameter
    doc: |
      The integer and fractional parts of the INT.FRAC float are used
      separately: the part after the decimal point sets the fraction of
      templates/pairs to be kept, while the integer part is used as a
      seed that influences which subset of reads is kept.
    type: float
    inputBinding:
      position: 0

  - id: input_bam
    label: Input BAM
    doc: Input file in BAM format
    type: File
    inputBinding:
      position: 1

  - id: output_bam
    label: Output BAM
    doc: Output (subsampled) BAM file
    type: string
    inputBinding:
      position: 2
      prefix: "-o"

outputs:
  - id: output
    label: Output
    doc: Output subsampled BAM file produced by samtools
    type: File
    outputBinding:
      glob: $(inputs.output_bam)
