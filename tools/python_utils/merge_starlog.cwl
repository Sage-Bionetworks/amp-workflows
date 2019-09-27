class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: merge_starlog
baseCommand:
  - starmerge.py
inputs:
  - id: logs
    type: 'File[]'
    inputBinding:
      position: 1
outputs:
  - id: starlog_merged
    type: File
    outputBinding:
      glob: '*Merged.txt'
label: merge_starlog
requirements:
  - class: DockerRequirement
    dockerPull: 'wpoehlm/ngstools:pyscript-8f5f7d9'
  - class: InlineJavascriptRequirement
