
## RNASeq Reprocessing Workflow
This workflow automates and standardizes the re-processing of RNASeq datasets from AMP-AD studies. 

### Dependencies 
* Docker
* A CWL execution engine ([cwltool](https://github.com/common-workflow-language/cwltool) or [toil](https://toil.readthedocs.io/en/latest/))

### Usage
Create or symlink a synapse config file in this directory.
Modify the `main.json` file to point to a
[synapse config file](https://docs.synapse.org/articles/client_configuration.html#customize-the-synapse-configuration-file).
In addition, they must provide an array of synapse IDs that correspond
to the BAM files that they would like to process.  

#### cwltool execution 

`cwl-runner main-paired.cwl main.json`

#### toil execution 

- ssh to toil cluster leader node
- from this directory (presuming the git repo was cloned to the leader),
- choose a job directory, for example, `jobs/test-main-paired`
- execute toil run script: `./run-toil.py jobs/test-main-paired`

Run `./run-toil.py -h` to see more options. Note that there is a `--dry-run`
option, which can help you to become familiar with the tool.

#### add more jobs
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

#### Single End Sequencing Reads

To run the workflow using datasets that contain single end sequencing reads, follow the above directions but replace `main-paired.cwl` with `main-single.cwl`

### Development

Use the `run-tests.sh` script to run tests. This script runs the [cwltest tool](https://github.com/common-workflow-language/cwltest/) inside a Docker container.
