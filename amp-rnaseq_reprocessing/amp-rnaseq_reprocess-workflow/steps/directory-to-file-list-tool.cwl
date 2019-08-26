#!/usr/bin/env cwl-runner

# from https://github.com/common-workflow-language/common-workflow-language/issues/700

cwlVersion: v1.0
class: ExpressionTool
requirements: { InlineJavascriptRequirement: {} }
inputs:
  - id: dir
    type: Directory
expression: |
  ${
    var filtered = []
    for (var n in inputs.dir.listing) {
      var o = inputs.dir.listing[n]
      if (o.class == "File"){
        filtered.push(o)
      }
    }
    return { "files": filtered }
  }
outputs:
  - id: files
    type: File[]

