class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: clean_tables
baseCommand:
  - clean_tables.py
inputs:
  - id: count_table
    type: File
  - id: star_table
    type: File
  - id: metric_table
    type: File
  - id: provenance_csv
    type: File
outputs:
  - id: clean_counts
    type: File
    outputBinding:
      glob: 'gene_all_counts_matrix_clean.txt'
  - id: clean_log
    type: File
    outputBinding:
      glob: 'Star_Log_Merged_clean.txt'
  - id: clean_metrics
    type: File
    outputBinding:
      glob: 'Study_all_metrics_matrix_clean.txt'
label: clean_tables.cwl
hints:
  - class: DockerRequirement
    dockerPull: wpoehlm/ngstools:pyscript-650ffc0
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.count_table)
      - $(inputs.star_table)
      - $(inputs.metric_table)
      - $(inputs.provenance_csv)


