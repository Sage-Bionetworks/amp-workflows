cwlVersion: v1.0
class: CommandLineTool
label: STAR spliced alignment
doc: |
  STAR: Spliced Transcripts Alignment to a Reference.
  https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

dct:creator:
  "@id": "http://orcid.org/0000-0003-3777-5945"
  foaf:name: "Tazro Ohta"
  foaf:mbox: "mailto:inutano@gmail.com"

hints:
  - class: DockerRequirement
    dockerPull: 'wpoehlm/ngstools:star'

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.genome_dir)

baseCommand: ['STAR', '--runMode', 'alignReads']

arguments:
#  - prefix: --genomeDir
#    valueFrom: "$(runtime.outdir)/$(inputs.genstr)"
  - prefix: --outFileNamePrefix
    valueFrom: "$(runtime.outdir)/$(inputs.output_dir_name)"

inputs:

#  - id: unaligned_reads_fastq
#    label: Unaligned reads FASTQ
#    doc: |
#      paths to files that contain input read1 (and, if needed, read2)
#    type: File[]
#    inputBinding:
#      position: 1
#      prefix: --readFilesIn
#      itemSeparator: ' '
#      shellQuote: false
  - id: mate_1_fastq
    type: File
    inputBinding:
      position: 1
      prefix: --readFilesIn

  - id: mate_2_fastq
    type: File?
    inputBinding:
      position: 2

#  - id: read_files_command
#    label: Read files command
#    type: string
#    default: "cat - "
#    inputBinding:
#      prefix: --readFilesCommand

  - id: genstr
    label: Reference genome directory
    doc: |
      path to the directory where genome files are stored
    type: string?
    default: .
    inputBinding:
      prefix: --genomeDir
  - id: genome_dir
    type: File[]
  - id: nthreads
    label: Number of threads
    doc: |
      defines the number of threads to be used for genome generation, it has
      to be set to the number of available cores on the server node.
    type: int
    inputBinding:
      prefix: --runThreadN

  - id: output_dir_name
    label: Output directory name
    doc: |
      Name of the directory to write output files in
    type: string
    default: "STAR"

  # - id: output_filename_prefix
  #   label: Output filename prefix
  #   type: string
  #   inputBinding:
  #     prefix: --outputFileNamePrefix
  #     valueFrom: $(inputs)

  - id: output_sam_type
    label: Output reads SAM/BAM
    doc: |
      1st word: BAM: output BAM without sorting, SAM: output SAM without
      sorting, None: no SAM/BAM output, 2nd, 3rd: Unsorted: standard unsorted,
      SortedByCoordinate: sorted by coordinate. This option will allocate
      extra memory for sorting which can be specified by –limitBAMsortRAM
    type: string[]
    default: ["BAM", "SortedByCoordinate"]
    inputBinding:
      prefix: --outSAMtype

  - id: output_sam_unmapped
    label: Unmapped reads action
    doc: |
      1st word: None: no output, Within: output unmapped reads within the main
      SAM file (i.e. Aligned.out.sam). 2nd word: KeepPairs: record unmapped
      mate for each alignment, and, in case of unsorted output, keep it
      adjacent to its mapped mate. Only a↵ects multi-mapping reads.
    type: string
    default: "Within"
    inputBinding:
      prefix: --outSAMunmapped

  - id: quant_mode
    label: Quantification method
    doc: |
      types of quantification requested. -: none, TranscriptomeSAM: output
      SAM/BAM alignments to transcriptome into a separate file, GeneCounts:
      count reads per gene
    type: string
    default: "GeneCounts"
    inputBinding:
      prefix: --quantMode

  - id: two_pass_mode
    label: Two-pass mode option
    doc: |
      STAR will perform the 1st pass mapping, then it will automatically
      extract junctions, insert them into the genome index, and, finally,
      re-map all reads in the 2nd mapping pass. This option can be used with
      annotations, which can be included either at the run-time, or at the
      genome generation step
    type: string
    default: "Basic"
    inputBinding:
      prefix: --twopassMode

outputs:
  - id: aligned_reads_sam
    label: Aligned reads SAM
    type: File
    outputBinding:
      glob: "*bam"

  # - id: transcriptome_aligned_reads_bam
  #   type: File
  #   outputBinding:
  #     glob: "*Aligned.toTranscriptome.out.bam"

  - id: reads_per_gene
    label: Reads per gene
    type: File
    outputBinding:
      glob: "*ReadsPerGene.out.tab"

  - id: splice_junctions
    label: Splice junctions
    type: File
    outputBinding:
      glob: "*SJ.out.tab"

  - id: logs
    label: STAR logs
    type: File[]
    outputBinding:
      glob: "*.out"
