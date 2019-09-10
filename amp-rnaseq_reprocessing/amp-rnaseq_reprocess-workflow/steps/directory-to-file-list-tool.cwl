#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: ExpressionTool
id: directory-to-file-list
label: Transform Directory type to File type
doc: Convert a directory type input to a file array output.

requirements:
  - class: InlineJavascriptRequirement

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

'dct:creator':
  '@id': 'http://orcid.org/0000-0002-4475-8396'
  'foaf:name': 'Tess Thyer'
  'foaf:mbox': 'mailto:tess.thyer@sagebionetworks.org'
