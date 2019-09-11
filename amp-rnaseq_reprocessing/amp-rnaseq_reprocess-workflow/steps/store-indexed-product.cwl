#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
doc: Store indexed files as well as source files.
label: Indexed files storage tool.
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: store.sh
        entry: |-
          #!/usr/bin/env bash
          set -x

          synapse login
          PROJECT=$(inputs.synapse_parent_id)
          synapse store --parentId $PROJECT $(inputs.genome_fasta_file.path)
          synapse store --parentId $PROJECT $(inputs.annotation_gtf_file.path)
          indexing_paths=($(Array.from(inputs.genome_index_files, function(item) {return item.path;}).join(' ')))
          for file_path in "\${indexing_paths[@]}"
          do
            synapse store --parentId $PROJECT $file_path
          done

      - entryname: .synapseConfig
        entry: $(inputs.synapse_config)
  - class: DockerRequirement
    dockerPull: sagebionetworks/synapsepythonclient:v1.9.2

baseCommand: ["bash", "store.sh"]

inputs:
  - id: synapse_config
    type: File
  - id: synapse_parent_id
    type: string
  - id: genome_fasta_file
    type: File
  - id: annotation_gtf_file
    type: File
  - id: genome_index_files
    type: File[]

outputs: []

'dct:creator':
  '@id': 'http://orcid.org/0000-0002-4475-8396'
  'foaf:name': 'Tess Thyer'
  'foaf:mbox': 'mailto:tess.thyer@sagebionetworks.org'
