#!/usr/bin/env bash
# Generate refFlat reference file for Picard CollectRnaSeqMetrics
# JAE for Sage Bionetworks
# February 24, 2017

# $1 = gene annotations (gene model) in GTF from Gencode

GTF=$1

# Specify output refFlat file path
REFFLAT="$(basename ${1} .annotation.gtf).refFlat.txt"

# Rearrange GTF columns to create refFlat file
gtfToGenePred -genePredExt $1 refFlat.tmp.txt
paste <(cut -f 12 refFlat.tmp.txt) <(cut -f 1-10 refFlat.tmp.txt) \
    > $REFFLAT
rm refFlat.tmp.txt
