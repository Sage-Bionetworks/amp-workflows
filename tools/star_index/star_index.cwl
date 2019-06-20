cwlVersion: v1.0
class: CommandLineTool
label: STAR genomeGenerate
doc: |
  Generate genome indexes for STAR.

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

  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
baseCommand: ['STAR', '--runMode', 'genomeGenerate']

arguments:

  - prefix: --genomeDir
    valueFrom: $(inputs.genstr)

inputs:

  - id: nthreads
    label: Number of threads
    doc: |
      defines the number of threads to be used for genome generation, it has
      to be set to the number of available cores on the server node.
    type: int
    inputBinding:
      prefix: --runThreadN

  - id: genome_fastas
    label: Genome sequence FASTAs
    doc: |
      specified one or more FASTA files with the genome reference sequences.
      Multiple reference sequences (henceforth called chromosomes) are allowed
      for each fasta file. You can rename the chromosomes names in the
      chrName.txt keeping the order of the chromo- somes in the file: the
      names from this file will be used in all output alignment files (such as
      .sam). The tabs are not allowed in chromosomes names, and spaces are not
      recommended.
    type: File
    inputBinding:
      prefix: --genomeFastaFiles

  - id: genemodel_gtf
    label: Gene model GTF
    doc: |
      specifies the path to the file with annotated transcripts in the
      standard GTF format. STAR will extract splice junctions from this file
      and use them to greatly improve accuracy of the mapping. While this is
      optional, and STAR can be run without annotations, using annotations is
      highly recommended whenever they are available. Starting from 2.4.1a,
      the annotations can also be included on the fly at the mapping step.
    type: File
    inputBinding:
      prefix: --sjdbGTFfile

  - id: sjdb_overhang
    label: Splice junction overhang
    doc: |
      specifies the length of the genomic sequence around the annotated
      junction to be used in constructing the splice junctions database.
      Ideally, this length should be equal to the ReadLength-1, where
      ReadLength is the length of the reads. For instance, for Illumina 2x100b
      paired-end reads, the ideal value is 100-1=99. In case of reads of
      varying length, the ideal value is max(ReadLength)-1. In most cases, the
      default value of 100 will work as well as the ideal value
    type: int
    default: 100
    inputBinding:
      prefix: --sjdbOverhang

  - id: genstr
    type: string?
    default: .
outputs:

  - id: genome_dir
    label: Reference genome directory
    type: File[]
    outputBinding:
      glob: "*"
