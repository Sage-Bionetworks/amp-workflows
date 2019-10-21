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
Whichever tool you choose to use, you will need to create or symlink a 
[synapse config file](https://docs.synapse.org/articles/client_configuration.html#customize-the-synapse-configuration-file)
to the path in `job.json` you run. The path we've chosen to add to the
`job.json` files is `/etc/synapse/.synapseConfig`. If you choose to place your
config file in a different location, remember to edit the path in `job.json`.

Subfolders under the `jobs` folder supply the following
* `options.json`, used in `run-toil.py`, see instructions below
* `job.json`, used to supply the cwl arguments, regardless of tool choice
* requirements files that supply the resource requirements to CWL workflows

#### cwltool execution
The following instructions are for running the `cwl-runner` in BASH. In the
example below, the job directory "jobs/test-main-paired" is used. Run this from the "amp-rnaseq_reprocess-workflow" directory.

*NOTE: this section is under development -- proceed with caution*

```bash
# Create environment variables necessary for generating provenance
export WORKFLOW_URL=$(utils/giturl.py)
export CWL_ARGS_URL=$(utils/giturl.py --raw --path jobs/test-main-paired/job.json)

# Create symlinks to resource files
links=$(utils/linkresources.py jobs/test-main-paired)

# Use cwltool to run a workflow
cwl-runner --preserve-entire-environment main-paired.cwl jobs/test-main-paired/job.json

# Remove symlinks
utils/unlinkresources.py $links
```

#### toil execution 

- ssh to toil cluster leader node
- from this directory (presuming the git repo was cloned to the leader),
- choose a job directory, for example, `jobs/test-main-paired`
- execute toil run script: `./run-toil.py jobs/test-main-paired`

Run `./run-toil.py -h` to see more options. Note that there is a `--dry-run`
option, which can help you to become familiar with the tool.

### How to Add More Jobs
To add a new job, create a new directory under `jobs`.

Each job directory requires an `options.json`, the set of options used by toil.
The `options.json` in `jobs/default` contains default options. Additional ones
can be added (or overwritten) in your job directory's `options.json`. The
`run-toil.py` script will warn you if any are missing.

Each job directory also requires a `job.json`. This contains the arguments that
are supplied to the CWL that you specify in your `options.json`.

For examples of both `options.json` and `job.json`, see `jobs/test-main-paired`.

Additionally, you can fine-tune the resource requirements. The resource 
requirement files that can be overwritten, and their default values, may be
found in `jobs/default`. Create files with the same name in your job directory
to overwrite the values.

#### Spot Bids
We provide a utility, `utils/aws-spotbid.py`, to generate a spot bid from aws.
Run this before you run your workflow to get a bid for your instance type, zone,
and ratio-of-max bid. This will give you a bid that you can used to modify your
`options.json` which will trigger the toil engine to request spot instances
instead of on-demand instances. For example, if I choose to use spot instances
in `jobs/test-main-paired/options.json`, I would run
`utils/aws-spotbid.py m5.4xlarge`, and the response will look something like

```
Based on ratio of 1.1, the recommended bid is 0.42449.
For comparision, the on-demand price is 0.768.
```

Then I would edit the `node_types` value in `options.json` to add the bid using
the syntax required by the toil engine:`m5.4xlarge:0.42449`

For more information on the utility's options, run  `utils/aws-spotbid.py -h`.

#### Single End Sequencing Reads

To run the workflow using datasets that contain single end sequencing reads, follow the above directions but replace `main-paired.cwl` with `main-single.cwl`
