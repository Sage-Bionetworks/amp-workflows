cwlVersion: v1.0
class: CommandLineTool

baseCommand: ['cat']
stdout: "$(inputs.output_basename).gz"

requirements:
  - class: InlineJavascriptRequirement

inputs:

  - id: input_gzs
    type: File[]
    inputBinding:
      position: 1

  - id: output_basename
    type: string

outputs:

  - id: output_gz
    type: File
    outputBinding:
      glob: "$(inputs.output_basename).gz"
