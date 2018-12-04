cwlVersion: v1.0
class: CommandLineTool

baseCommand: ['gzip', '-c']
stdout: "$(inputs.input_file.path.split('/').slice(-1)[0]).gz"

requirements:
  - class: InlineJavascriptRequirement

inputs:

  - id: input_files
    type: File
    inputBinding:
      position: 1

outputs:

  - id: output_gz
    type: File
    outputBinding:
      glob: "$(inputs.input_file.path.split('/').slice(-1)[0]).gz"
