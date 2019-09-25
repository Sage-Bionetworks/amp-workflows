class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: sample_provenance
baseCommand:
  - provenance.py
inputs:
  - id: infile
    type: File
    inputBinding:
      position: 1
  - id: synapseconfig
    type: File
    inputBinding:
      position: 2
outputs:
  - id: provenance_csv
    type: File
    outputBinding:
      glob: '*csv*'
label: provenance.cwl
hints:
  - class: DockerRequirement
    dockerPull: 'wpoehlm/ngstools:pyscript-3a97325'
