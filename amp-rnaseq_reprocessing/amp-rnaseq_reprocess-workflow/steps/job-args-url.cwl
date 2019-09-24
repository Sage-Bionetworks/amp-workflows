#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
id: job-args-url
doc: |-
  For a relative job argument url path, construct its git repository link.
  Arguments:
  * job_args_url: url to the job arguments file for entry workflow in a git repository
  * job_args_path: path to the job args file (supplied to tool with entry workflow)
  * git_dir: path to the .git directory of the local clone

  Either job_args_url or both job_args_path and git_dir must be supplied. If the
  latter pair, the url returned will be in the github format.

  Example 1:
    job_args_url: https://github.com/Sage-Bionetworks/amp-workflows/blob/89c4448d281b280c8a081810a91b5f803be69cf2/amp-rnaseq_reprocessing/amp-rnaseq_reprocess-workflow/jobs/test-main-paired/job.json

  Example 2:
    job_args_path: jobs/test-main-paired/job.json
    git_dir: /Users/whozit/code/amp-workflows/.git

label: Job arguments file url constructor
$namespaces:
  dct: 'http://purl.org/dc/terms/'
  foaf: 'http://xmlns.com/foaf/0.1/'
  sbg: 'https://www.sevenbridges.com/'

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: job-args-url.sh
        entry: |-
          #!/usr/bin/env bash

          JOB_ARGS_URL=$(inputs.job_args_url)
          RELATIVE_PATH=$(inputs.job_args_path)
          GIT_DIR=$(inputs.git_dir)
          ERROR=""
          URL=""

          json() {
            JSON_FMT='{"url":"%s", "error":"%s"}'
            printf "\$JSON_FMT" "\$URL" "\$ERROR"
          }

          if [[ \$JOB_ARGS_URL == null ]] && [[ \$RELATIVE_PATH == null || \$GIT_DIR == null ]]; then
            ERROR="If job_args_url is missing, then you must specify both job_args_path and git_dir"
            json
            exit 1
          fi


          if [[ \$JOB_ARGS_URL != null ]]; then
            URL=\$JOB_ARGS_URL
          else

            REMOTE=\$(git --git-dir=\${GIT_DIR} remote get-url origin)
            # If the remote is in ssh form, convert to https
            if [[ "\$REMOTE" == git* ]]; then
              # remove the git@
              REMOTE=\$(cut -d'@' -f2 <<<"\$REMOTE")
              # replace colon with forward slash
              REMOTE="\${REMOTE/://}"
              # add the https protocol string
              REMOTE="https://\$REMOTE"
            fi

            # both ssh and https remotes need the ending ".git" removed
            REMOTE="\${REMOTE::\${#REMOTE}-4}"

            SHA=\$(git --git-dir=\${GIT_DIR} rev-parse HEAD)
            CLONE_DIR="\${GIT_DIR::\${#GIT_DIR}-4}"
            PATH_FROM_ROOT=\$(find \${CLONE_DIR} -path "*\$RELATIVE_PATH")
            PATH_FROM_ROOT=\$(printf '%s' "\${PATH_FROM_ROOT//\$CLONE_DIR/}")
            URL="\${REMOTE}/blob/\${SHA}\${PATH_FROM_ROOT}"
          fi

          json

baseCommand: ["bash", "job-args-url.sh"]

inputs:
  - id: job_args_path
    type: string?
  - id: git_dir
    type: string?
  - id: job_args_url
    type: string?

stdout: json

outputs:
  - id: job_args_url
    type: string
    outputBinding:
      glob: json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents).url)
  - id: error
    type: string
    outputBinding:
      glob: json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents).error)

'dct:creator':
  '@id': 'http://orcid.org/0000-0002-4475-8396'
  'foaf:name': 'Tess Thyer'
  'foaf:mbox': 'mailto:tess.thyer@sagebionetworks.org'
