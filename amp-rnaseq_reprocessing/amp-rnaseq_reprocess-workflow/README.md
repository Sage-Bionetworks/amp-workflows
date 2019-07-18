
## RNASeq Reprocessing Workflow
This workflow automates and standardizes the re-processing of RNASeq datasets from AMP-AD studies. 

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
