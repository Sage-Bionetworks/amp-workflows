#!/usr/bin/env cwl-runner
#

cwlVersion: v1.0
class: CommandLineTool
baseCommand: synapse

hints:
  DockerRequirement:
    dockerPull: sagebionetworks/synapsepythonclient:v1.9.2

inputs:
  - id: synapse_config
    type: File
  - id: synapseid
    type: string

requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: .synapseConfig
        entry: $(inputs.synapse_config)

arguments: ["get", "-r", $(inputs.synapseid)]
     
outputs:
  - id: output_dir
    type: Directory
    outputBinding:
      glob: '.'

