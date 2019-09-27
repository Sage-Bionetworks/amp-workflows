class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: upload_synapse
hints:
  DockerRequirement:
    dockerPull: 'wpoehlm/ngstools:pyscript-8f5f7d9'
baseCommand:
  - synstore.py
inputs:
  - id: infile
    type: File
    inputBinding:
      position: 1
  - id: parentid
    type: string
    inputBinding:
      position: 2
  - id: synapseconfig
    type: File
    inputBinding:
      position: 3
  - id: argurl
    type: string
    inputBinding:
      position: 4
  - id: wfurl
    type: string
    inputBinding:
      position: 5
outputs: []
label: upload_synapse.cwl


