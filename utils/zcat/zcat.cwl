cwlVersion: v1.0
class: CommandLineTool

baseCommand: ['cat']
stdout: "$(inputs.output_basename).gz"

requirements:
  - class: InlineJavascriptRequirement

inputs:

  - id: input_gzs
    label: Input gzipped files
    type: File[]
    inputBinding:
      position: 1

  - id: output_basename
    type: string

outputs:

  - id: output_gz
    label: Concatenated gzipped file
    type: File
    outputBinding:
      glob: "$(inputs.output_basename).gz"
