#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0

doc: |
  Calculate quality metrics for each sample using Picard.

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

dct:creator:
  "@id": "http://orcid.org/0000-0001-9758-0176"
  foaf:name: "James Eddy"
  foaf:mbox: "mailto:james.a.eddy@gmail.com"

inputs:
  reads_bam:
    type: File

outputs:
  combined_metrics_csv:
    type: File

steps:
  picard_alignmentsummary:
    label: ...
    doc: |
      ...
    run: steps/picard_alignmentsummary_metrics.cwl
    in:
      input_bam: reads_bam
    out: [output_metrics]

  picard_rnaseq:
    label: ...
    doc: |
      ...
    run: steps/picard_rnaseq_metrics.cwl
    in:
      input_bam: reads_bam
    out: [output_metrics]

  combine_metrics_sample:
    label: ...
    doc: |
      ...
    run: steps/combine_metrics_sample.cwl
    in:
      ...
    out:
      ...

  combine_metrics_study:
    label: ...
    doc: |
      ...
    run: steps/combine_metrics_study.cwl
    in:
      ...
    out:
      ...
