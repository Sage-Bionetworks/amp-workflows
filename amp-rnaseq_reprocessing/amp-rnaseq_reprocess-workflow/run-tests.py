#! /usr/bin/env python

import os
import subprocess

from mockproc import mockprocess

os.symlink('test-data/resources-getindexes.yaml', 'resources-getindexes.yaml')

procs = mockprocess.MockProc()
synapse_script = '''#! /usr/bin/env python
with open('foo.txt', 'w') as newfile:
    newfile.write('foobar')
with open('bar.gtf', 'w') as newfile:
    newfile.write('barbaz')
with open('baz.fa', 'w') as newfile:
    newfile.write('bazfoo')
'''

procs.append('synapse', returncode=0, script=synapse_script)

with procs:
    subprocess.call([
      'cwltest',
      '--verbose',
      '--test', 'test-descriptions.yaml',
      '--tool', 'cwltool',
      '--test-arg', 'no_container==--no-container'
      ])

os.unlink('resources-getindexes.yaml')