#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0

doc: |
  Subsample one or more BAM files stored in Synapse.

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

dct:creator:
  "@id": "http://orcid.org/0000-0001-9758-0176"
  foaf:name: "James Eddy"
  foaf:mbox: "mailto:james.a.eddy@gmail.com"

inputs:
  input_synid:
    type: string
  syn_config:
    type: File

outputs:
  output_bam:
    type: File
    outputSource: subsample/output_bam

steps:
  load_data:
    label: data loader
    doc: |
      This step retrieves the input data file from Synapse using the
      `synapse get` command encapsulated in a CWL tool.
    run: synget.cwl
    in:
      synid: input_synid
      config: syn_config
    out: [synout]

  subsample:
    label: subsample BAM file
    doc: |
      This step downsamples a BAM file to a fraction of reads/pairs.
    run: steps/samtools_subsample/subsample_bam.cwl
    in:
      input_bam: load_data/synout
    out: [output_bam]
