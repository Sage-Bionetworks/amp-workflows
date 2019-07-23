#!/usr/bin/env python

## Author: <william.poehlman@sagebase.org> ##
## First write: 07/22/2019 ##
## This script merges log files from the STAR read aligner and creates a report file ##
import sys
import os
import glob

#outpath = sys.argv[1]
#os.chdir(outpath)

inputs =  []
for i in sys.argv[1:]:
    inputs.append(i)
logdict = {}
fieldlist = []
outf = "Star_Log_Merged.txt"

for item in inputs:
    sample = item.split('Log')[0].split('/')[-1]
    logdict[sample] = {}

    for line in open(item):
        if '|' in line:
            field = str(line.split('|')[0]).strip()
            value = str(line.split('|')[1]).strip()
            if field not in fieldlist:
                fieldlist.append(field)
            logdict[sample].update({field: value})

with open(outf, 'a') as f:
    f.write('Sample' + '\t')
    for item in fieldlist:
        f.write(item + '\t')
    f.write('\n')
    for sample in logdict:
        f.write(sample + '\t')
        for item in fieldlist:
            f.write(logdict[sample][item] + '\t')
        f.write('\n')
    f.close()

print(fieldlist)

