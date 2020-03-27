#!/usr/bin/env Rscript
# Combine individual sample count files into a gene x sample matrix file
# JAE for Sage Bionetworks
# April 12, 2017

library(argparse)
library(readr)
library(stringr)
library(tidyr)
library(purrr)
library(dplyr)

parser = ArgumentParser(description = "Combine sample count files into a matrix file (rows of features by columns of samples).")
parser$add_argument('file_list', type = "character", nargs = "+",
                    help = "List of read count files to combine.")
parser$add_argument('--out_prefix', type = "character", required = TRUE,
                    help = "Prefix for output files (i.e., <prefix>_all_counts_matrix.txt).")
parser$add_argument('--sample_suffix', type = "character",
                    default = "ReadsPerGene.out.tab",
                    help = "Suffix to strip from sample filename [default %(default)s].")
parser$add_argument('--out_dir', default = getwd(), type = "character",
                    help = "Directory in which to save output [default %(default)s].")
parser$add_argument('--col_num', default = 2, type = "integer",
                    help = "1-based index of counts column to select [default %(default)s].")
args = parser$parse_args()

# Extract sample names from file names
names(args$file_list) <- map_chr(args$file_list, function(file_path) {
    basename(file_path) %>%
        str_replace(args$sample_suffix, "")
    })

# Save the first column of the first file to a vector to use for ordering
# rows in the combined matrix
feature_order <- read_tsv(args$file_list[1],
                          col_names = FALSE,
                          col_types = "ciii")[["X1"]]

# Merge all columns into a single data frame; note: identifiers (e.g., gene
# names) in the first column will be stored in the "feature" column
message("Combining counts for all samples...")
combined_counts <- map_df(args$file_list, function(file_path) {
    read_tsv(file_path, col_names = FALSE, col_types = "ciii") %>%
        .[, c(1, args$col_num)] %>%
        set_names(c("feature", "count")) %>%
        mutate(feature = factor(feature, levels = feature_order))
    },
    .id = "sample") %>%
    spread(sample, count)

# Write data frame as tab-delimited matrix file
message("Saving output...")
out_file <- file.path(args$out_dir,
                      paste0(args$out_prefix, "_all_counts_matrix.txt"))
write_tsv(combined_counts, out_file)
