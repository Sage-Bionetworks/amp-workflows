#!/usr/bin/env Rscript
# Combine individual sample metric files into a sample x metric matrix file.
# JAE for Sage Bionetworks
# April 13, 2017

library(argparse)
library(readr)
library(stringr)
library(tidyr)
library(purrr)
library(dplyr)

parser = ArgumentParser(description = "Combine sample metric files into a matrix file (rows of samples by columns of metrics).")
parser$add_argument('file_list', type = "character", nargs = "+",
                    help = "List of Picard metrics files to combine.")
parser$add_argument('--out_prefix', type = "character", required = TRUE,
                    help = "Prefix for output files (i.e., <prefix>_all_metrics_matrix.txt).")
parser$add_argument('--sample_suffix', type = "character",
                    default = "_picard.CombinedMetrics.csv",
                    help = "Suffix to strip from sample filename [default %(default)s].")
parser$add_argument('--out_dir', default = getwd(), type = "character",
                    help = "Directory in which to save output [default %(default)s].")
args = parser$parse_args()

# Extract sample names from file names
names(args$file_list) <- map_chr(args$file_list, function(file_path) {
    basename(file_path) %>%
        str_replace(args$sample_suffix, "")
    })

# Merge all rows into a single data frame; note: sample names (parsed from
# file names) will be stored in the "sample" column
message("Combining metrics for all samples...")
combined_metrics <- map_df(args$file_list, read_csv, .id = "sample")

# Write data frame as tab-delimited matrix file
message("Saving output...")
out_file <- file.path(args$out_dir,
                      paste0(args$out_prefix, "_all_metrics_matrix.txt"))
write_tsv(combined_metrics, out_file)
