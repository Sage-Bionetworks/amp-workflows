#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
inputs: []
stdout: echo_out
outputs:
  - id: cwl_wf_url
    type: string
    outputBinding:
      glob: echo_out
      loadContents: true
      outputEval: $(self[0].contents)
baseCommand: echo
arguments: ["-n", { valueFrom: '"$WORKFLOW_URL"', shellQuote: false} ]
requirements:
  ShellCommandRequirement: {}
