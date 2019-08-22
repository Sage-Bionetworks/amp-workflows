class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: concat_fq
baseCommand:
  - cat
requirements:
  - class: InlineJavascriptRequirement
stdout: "$(inputs.outname)"
inputs:
  - id: input1
    type: File
    inputBinding:
      position: 0
  - id: input2
    type: File
    inputBinding:
      position: 0
  - id: outname
    type: string
outputs:
  - id: fqmerged
    type: File
    outputBinding:
      glob: "$(inputs.outname)"
label: concat_fq
arguments:
  - position: 0

