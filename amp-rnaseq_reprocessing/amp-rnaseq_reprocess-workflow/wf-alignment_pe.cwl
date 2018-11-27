#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0

doc: |
  Align RNA-seq data for each sample using STAR.

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

dct:creator:
  "@id": "http://orcid.org/0000-0001-9758-0176"
  foaf:name: "James Eddy"
  foaf:mbox: "mailto:james.a.eddy@gmail.com"

inputs:
  reads_fastq:
    type: File

outputs:
  reads_bam:
    type: File

steps:
  star_index:
    label: build STAR genome index
    doc: |
      This step builds the index from a FASTA sequence for the specified
      genome to be used with the STAR spliced read aligner.
    run: steps/star_index/star_index.cwl
    in:
      input_fasta: genome_fasta
    out: [output_index]

  star_align:
    label: align RNA-seq reads with STAR
    doc: |
      This step maps RNA-seq reads to the specified genome using the STAR
      spliced read aligner.
    run: steps/star_align/star_align_pe.cwl
    in:
      input_fastq: reads_fastq
    out: [output_bam]
