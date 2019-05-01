class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: picard_sortsam
baseCommand:
  - picard.sh
  - SortSam
inputs:
  - id: aligned_reads_sam
    type: File
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false
    label: Aligned reads SAM
    doc: Reads data file in SAM (or BAM) format
  - default: queryname
    id: sort_order
    type: string
    inputBinding:
      position: 2
      prefix: SORT_ORDER=
      separate: false
    label: Sort order
  - default: 'true'
    id: quiet
    type: string
    inputBinding:
      position: 3
      prefix: QUIET=
      separate: false
    label: Verbosity (QUIET)
  - default: SILENT
    id: validation_stringency
    type: string
    inputBinding:
      position: 4
      prefix: VALIDATION_STRINGENCY=
      separate: false
    label: Validation stringency
  - default: 0
    id: compression_level
    type: int
    inputBinding:
      position: 5
      prefix: COMPRESSION_LEVEL=
      separate: false
    label: Compression level
  - id: sorted_reads_filename
    type: string
    inputBinding:
      position: 6
      prefix: OUTPUT=
      separate: false
    label: Sorted SAM filename
outputs:
  - id: sorted_reads_bam
    doc: Sorted SAM (or BAM) file
    label: Sorted reads SAM
    type: File
    outputBinding:
      glob: '*.bam'
doc: |
  Use Picard to sort a SAM or BAM file.

  Original command:
  java -Xmx8G -jar $PICARD SortSam \
    INPUT="${indir}/${1}" \
    OUTPUT=/dev/stdout \
    SORT_ORDER=queryname \
    QUIET=true \
    VALIDATION_STRINGENCY=SILENT \
    COMPRESSION_LEVEL=0
label: Picard SortSam
arguments:
  - position: 0
requirements:
  - class: ResourceRequirement
    ramMin: 100
    coresMin: 1
  - class: InlineJavascriptRequirement
hints:
  - class: DockerRequirement
    dockerPull: 'wpoehlm/ngstools:picard'
