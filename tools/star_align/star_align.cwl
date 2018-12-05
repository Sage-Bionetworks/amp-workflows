cwlVersion: v1.0
class: CommandLineTool
label: "STAR mapping: running mapping jobs."
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
  DockerRequirement:
    dockerPull: 'quay.io/sage-bionetworks/star_utils:1.0'

baseCommand: ['STAR', '--runMode', 'alignReads']

arguments:

  - prefix: --outFileNamePrefix
    valueFrom: "$(runtime.outdir)/$(inputs.output_dir_name)"

inputs:

  - id: unaligned_reads_fastq
    label: Unaligned reads FASTQ
    doc: |
      paths to files that contain input read1 (and, if needed, read2)
    type: File[]
    inputBinding:
      prefix: --readFilesIn
      itemSeparator: ","

  - id: genome_dir
    label: Reference genome directory
    doc: |
      path to the directory where genome files are stored
    type: Directory
    inputBinding:
      prefix: --genomeDir

  - id: num_threads
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
    default: ["BAM", "Unsorted"]
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
    type: string[]
    default: ["TranscriptomeSAM", "GeneCounts"]
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

  - id: read_files_command
    label: Read files command
    type: string
    inputBinding:
      prefix: --readFilesCommand

  # - id: outSJfilterReads
  #   label: which reads to consider for collapsed splice junctions output
  #   doc: |
  #     which reads to consider for collapsed splice junctions output. All: all
  #     reads, unique- and multi-mappers, Unique: uniquely mapping reads only.
  #   type: string
  #   default: "Unique"
  #   inputBinding:
  #     prefix: --outSJfilterReads
  #
  # - id: outFilterType
  #   label: Filter type
  #   doc: |
  #     Normal: standard filtering using only current alignment, BySJout: keep
  #     only those reads that contain junctions that passed filtering into
  #     SJ.out.tab
  #   type: string
  #   default: "BySJout"
  #   inputBinding:
  #     prefix: --outFilterType
  #
  # - id: output_sam_attributes
  #   label: Output SAM attributes
  #   doc: |
  #     NH: any combination in any order, Standard: NH HI AS nM, All: NH HI AS
  #     nM NM MD jM jI ch, None: no attributes
  #   type: string[]
  #   default: ["NH", "HI", "AS", "NM", "MD"]
  #   inputBinding:
  #     prefix: --outSAMattributes
  #
  # - id: outFilterMultimapNmax
  #   label: Maximum loci mappings
  #   doc: |
  #     maximum number of loci the read is allowed to map to. Alignments (all of
  #     them) will be output only if the read maps to no more loci than this
  #     value. Otherwise no alignments will be output, and the read will be
  #     counted as ”mapped to too many loci” in the Log.final.out .
  #   type: int
  #   default: 20
  #   inputBinding:
  #     prefix: --outFilterMultimapNmax
  #
  # - id: outFilterMismatchNmax
  #   label: alignment will be output only if it has no more mismatches than this value
  #   doc: |
  #       alignment will be output only if it has no more mismatches than this
  #       value
  #   type: int
  #   default: 999
  #   inputBinding:
  #     prefix: --outFilterMismatchNmax
  #
  # - id: alignIntronMin
  #   label: Minimum intron size
  #   doc: |
  #     minimum intron size: genomic gap is considered intron if its
  #     length>=alignIntronMin, otherwise it is considered Deletion
  #   type: int
  #   default: 20
  #   inputBinding:
  #     prefix: --alignIntronMin
  #
  # - id: outFilterMismatchNoverReadLmax
  #   label: Maximum mistmatch rate
  #   doc: |
  #     alignment will be output only if its ratio of mismatches to *read*
  #     length is less than or equal to this value.
  #   type: float
  #   default: 0.04
  #   inputBinding:
  #     prefix: --outFilterMismatchNoverReadLmax
  #
  # - id: alignIntronMax
  #   label: Maximum intron size
  #   doc: |
  #     maximum intron size, if 0, max intron size will be determined by
  #     (2ˆwinBinNbits)*winAnchorDistNbins
  #   type: int
  #   default: 1000000
  #   inputBinding:
  #     prefix: --alignIntronMax
  #
  # - id: alignMatesGapMax
  #   label: Maximum between-mates gap
  #   doc: |
  #     maximum gap between two mates, if 0, max intron gap will be determined
  #     by (2ˆwinBinNbits)*winAnchorDistNbins
  #   type: int
  #   default: 1000000
  #   inputBinding:
  #     prefix: --alignMatesGapMax
  #
  # - id: alignSJoverhangMin
  #   label: Minimum spliced alignments overhang
  #   doc: |
  #     minimum overhang (i.e. block size) for spliced alignments
  #   type: int
  #   default: 8
  #   inputBinding:
  #     prefix: --alignSJoverhangMin
  #
  # - id: alignSJDBoverhangMin
  #   label: Minimum annotated (sjdb) spliced alignments overhang
  #   doc: |
  #     minimum overhang (i.e. block size) for annotated (sjdb) spliced
  #     alignments
  #   type: int
  #   default: 1
  #   inputBinding:
  #     prefix: --alignSJDBoverhangMin
  #
  # - id: sjdb_score
  #   label: Spice junction database score
  #   doc: |
  #     extra alignment score for alignments that cross database junctions
  #   type: int
  #   default: 1
  #   inputBinding:
  #     prefix: --sjdbScore
  #
  # - id: bam_compression
  #   label: BAM compression level
  #   doc: |
  #     BAM compression level, -1=default compression (6?), 0=no compression,
  #     10=maximum compression
  #   type: int
  #   default: 10
  #   inputBinding:
  #     prefix: --outBAMcompression
  #
  # - id: sort_mem_limit
  #   label: Maximum RAM for sorting BAM
  #   doc: |
  #     maximum available RAM for sorting BAM. If =0, it will be set to the
  #     genome index size. 0 value can only be used with –genomeLoad
  #     NoSharedMemory option
  #   type: long?
  #   inputBinding:
  #     prefix: --limitBAMsortRAM
  #
  # - id: transcriptome_bam_compression
  #   label: Transcriptome BAM compression level
  #   doc: |
  #     transcriptome BAM compression level, -1=default compression (6?), 0=no
  #     compression, 10=maximum compression
  #   type: int
  #   default: 10
  #   inputBinding:
  #     prefix: --quantTranscriptomeBAMcompression
  #
  # - id: strand_field_flag
  #   label: Strand field flag
  #   doc: |
  #     Cuffinks-like strand field flag. None: not used, intronMotif: strand
  #     derived from the intron motif. Reads with inconsistent and/or
  #     non-canonical introns are filtered out.
  #   type: string
  #   default: "intronMotif"
  #   inputBinding:
  #     prefix: --outSAMstrandField

outputs:
  - id: aligned_reads_bam
    type: File
    outputBinding:
      glob: "*Aligned.out.bam"

  # - id: transcriptome_aligned_reads_bam
  #   type: File
  #   outputBinding:
  #     glob: "*Aligned.toTranscriptome.out.bam"

  - id: reads_per_gene
    type: File
    outputBinding:
      glob: "*ReadsPerGene.out.tab"

  - id: splice_junctions
    type: File
    outputBinding:
      glob: "*SJ.out.tab"

  - id: logs
    type: File[]
    outputBinding:
      glob: "*.out"
