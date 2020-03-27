#!/usr/bin/env bash
# Generate ribosomal intervals reference file for Picard CollectRnaSeqMetrics
# JAE for Sage Bionetworks
# February 24, 2017

# modified from https://gist.github.com/slowkow/b11c28796508f03cdf4b
# $1 = gene annotations (gene model) in GTF from Gencode
# $2 = path to example BAM file generated with same reference version as GTF

# Gene annotations in GTF from Gencode
GTF=$1
BAM=$2

# Specify output ribosomal intervals file path
rRNA="$(basename ${1} .annotation.gtf).rRNA.interval_list"

# Extract sequence names and lengths from BAM header
samtools view -H $2 \
    | awk 'OFS="\t" {print $1,$2,$3}' \
    > $rRNA

# Extract, sort, and add intervals for rRNA transcripts
grep 'gene_type "rRNA"' $GTF \
    | awk '$3 == "transcript"' \
    | cut -f1,4,5,7,9 \
    | perl -lane '
        /transcript_id "([^"]+)"/ or die "no transcript_id on $.";
        print join "\t", (@F[0,1,2,3], $1)
    ' \
    | sort -k1V -k2n -k3n \
    >> $rRNA
