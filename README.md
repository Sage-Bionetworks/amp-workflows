# amp-workflows
Standardized workflows for AMP-AD data processing and analysis

## RNASeq Reprocessing Workflow
This workflow automates and standardizes the re-processing of RNASeq datasets from AMP-AD studies. 

### Dependencies 
* Docker
* A CWL execution engine ([cwltool](https://github.com/common-workflow-language/cwltool), for example)
### Usage
Users must modify the *main.json* file to point to their synapse config file.  In addition, they must provide an array of synapse ID's that correspond to the BAM files that they would like to process.  To execute the workflow using the CWL reference implementation:

`cwl-runner main-paired.cwl main.json`
