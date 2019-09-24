class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: upload_synapse
hints:
  DockerRequirement:
    dockerPull: 'wpoehlm/ngstools:pyscript-89c4448'
baseCommand:
  - synstore.py
inputs:
  - id: infile
    type: File
    inputBinding:
      position: 1
  - id: wflink
    type: string
    inputBinding:
      position: 2
  - id: parentid
    type: string
    inputBinding:
      position: 3
  - id: usedent
    type: string
    inputBinding:
      position: 4
  - id: synapseconfig
    type: File
    inputBinding:
      position: 5
outputs: []
label: upload_synapse.cwl


