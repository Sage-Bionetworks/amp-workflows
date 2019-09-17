class: Workflow
cwlVersion: v1.0
doc: |
  Build genome and transcriptome indexes for alignment, quantification.
label: Index building sub-workflow
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: genome_fasta_url
    type: string
  - id: genome_fasta_filename
    type: string
  - id: annotation_gtf_url
    type: string
  - id: annotation_gtf_filename
    type: string
  - id: nthreads
    type: int
  - id: genstr
    type: string?
  - id: output_synapse_id
    type: string
  - id: synapse_config
    type: File
outputs: []
steps:
  - id: fetch_genome
    in:
      - id: genome_fasta_url
        source: genome_fasta_url
      - id: genome_fasta_filename
        source: genome_fasta_filename
      - id: annotation_gtf_url
        source: annotation_gtf_url
      - id: annotation_gtf_filename
        source: annotation_gtf_filename
    out:
      - id: genome_fasta_file
      - id: annotation_gtf_file
    run: steps/fetch_genome.cwl
  - id: star_index
    in:
      - id: nthreads
        source: nthreads
      - id: genome_fastas
        source: fetch_genome/genome_fasta_file
      - id: genemodel_gtf
        source: fetch_genome/annotation_gtf_file
      - id: genstr
        source: genstr
    out:
      - id: genome_dir
    run: steps/star_index.cwl
    label: STAR genomeGenerate
  - id: store
    in:
      - id: genome_index_files
        source: star_index/genome_dir
      - id: genome_fasta_file
        source: fetch_genome/genome_fasta_file
      - id: annotation_gtf_file
        source: fetch_genome/annotation_gtf_file
      - id: synapse_config
        source: synapse_config
      - id: synapse_parent_id
        source: output_synapse_id
    out: []
    run: steps/store-indexed-product.cwl
requirements: 
  - class: StepInputExpressionRequirement
  - class: ResourceRequirement
    $mixin: resources-buildindexes.yaml

'dct:creator':
  '@id': 'http://orcid.org/0000-0001-9758-0176'
  'foaf:mbox': 'mailto:james.a.eddy@gmail.com'
  'foaf:name': 'James Eddy'
'dct:contributor':
  '@id': 'https://orcid.org/0000-0002-3659-9663'
  'foaf:mbox': 'mailto:william.poehlman@sagebionetworks.org'
  'foaf:name': 'William Poehlman'
'dct:contributor':
  '@id': 'http://orcid.org/0000-0002-4475-8396'
  'foaf:name': 'Tess Thyer'
  'foaf:mbox': 'mailto:tess.thyer@sagebionetworks.org'

