cwlVersion: v1.0
class: CommandLineTool

baseCommand: ['gzip', '-c']
stdout: "$(inputs.input_file.path.split('/').slice(-1)[0]).gz"

requirements:
  - class: InlineJavascriptRequirement

inputs:

  - id: input_file
    label: Input file
    type: File
    inputBinding:
      position: 1

outputs:

  - id: output_gz
    label: Output gzipped file
    type: File
    outputBinding:
      glob: "$(inputs.input_file.path.split('/').slice(-1)[0]).gz"
