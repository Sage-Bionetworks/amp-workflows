#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
inputs: []
stdout: echo_out
outputs:
  - id: cwl_args_url
    type: string
    outputBinding:
      glob: echo_out
      loadContents: true
      outputEval: $(self[0].contents)
baseCommand: echo
arguments: ["-n", { valueFrom: '"$CWL_ARGS_URL"', shellQuote: false} ]
requirements:
  ShellCommandRequirement: {}
