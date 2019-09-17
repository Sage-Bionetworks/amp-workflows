## RNASeq Reprocessing Workflow
This workflow automates and standardizes the re-processing of RNASeq datasets from AMP-AD studies. The following steps are performed:

* Download input BAM alignment files using the [Synapse Client](https://python-docs.synapse.org//build/html/CommandLineClient.html)
* Sort input BAM alignment files using [Picard SortSam](https://broadinstitute.github.io/picard/command-line-overview.html#SortSam)
* Convert sorted BAM files into FastQ files using [Picard SamToFastQ](https://broadinstitute.github.io/picard/command-line-overview.html#SamToFastq)
* Align reads to the reference genome using the [STAR Aligner](https://github.com/alexdobin/STAR)
* Generate raw gene expression counts using the [STAR Aligner](https://github.com/alexdobin/STAR) --quantMode (similar to the HTSeq algorithm)
* Collect RNASeq metrics from re-aligned bam files using [Picard CollectRNASeqMetrics](https://broadinstitute.github.io/picard/command-line-overview.html#CollectRnaSeqMetrics)
* Collect Alignment summary statistics from re-aligned bam files using [Picard AlignmentSummaryMetrics](https://broadinstitute.github.io/picard/command-line-overview.html#CollectAlignmentSummaryMetrics)

### Dependencies 
* Docker
* A CWL execution engine ([cwltool](https://github.com/common-workflow-language/cwltool) or [toil](https://toil.readthedocs.io/en/latest/))
### Usage
Users must modify the *main.json* file to point to their synapse config file.  In addition, they must provide an array of synapse ID's that correspond to the BAM files that they would like to process.  

#### cwltool execution 
`cwl-runner main-paired.cwl main.json`

#### toil execution 

- ssh to toil cluster leader node
- modify `run-toil.sh` to specify resource requests
- execute toil run script:
```bash
chmod +x run-toil.sh
./run-toil.sh
```

#### Single End Sequencing Reads

To run the workflow using datasets that contain single end sequencing reads, follow the above directions but replace `main-paired.cwl` with `main-single.cwl`

### Development

Use the `run-tests.sh` script to run tests. This script runs the [cwltest tool](https://github.com/common-workflow-language/cwltest/) inside a Docker container.
