#!/usr/bin/env Rscript
# Combine individual sample quant files into a sample x gene matrix file
# KKD for Sage Bionetworks
# July 7, 2016

library(argparse)

parser = ArgumentParser(description='Collect and sum individual sample quant files into a matrix file.')
parser$add_argument('--oPrefix', type="character", required=TRUE, help='Prefix for output files.')
parser$add_argument('--quantCol', type="integer", required=TRUE, help='The 1-based position of the column to extract.')
parser$add_argument('--header', action="store_true", help='Set if input files have header to exclude [default %(default)s].')
parser$add_argument('--wd', default = getwd(), type="character", help='Directory of input files [default %(default)s].')
parser$add_argument('--splitChar', default="_", type="character", help='Character on which to split the count file names [default %(default)s].')
parser$add_argument('--segKeep', default=2, type="integer", help='Number of filename seqments to retain for sample-level aggregation [default %(default)s].')
args = parser$parse_args()

setwd(args$wd)
x = dir()

samples = sapply(as.list(x),function(x){paste(unlist(strsplit(x,args$splitChar))[1:args$segKeep],collapse = "_")})
head(samples)
length(samples)
length(x)
firstData = read.delim(x[1], header = args$header, row.names =1)
ENSGnames = rownames(firstData)
expectedLength = nrow(firstData)

readHTS=function(inFile,inCol=args$quantCol,rNames=ENSGnames,nrows=expectedLength){
	print(inFile)
	data = read.delim(inFile, header = args$header, row.names =1)
    if (! nrow(data) == nrows) {
  		stop(paste("Different number of input lines", inFile, sep = " "))
	}
  nameCheck = which((rownames(data) == rNames) == FALSE)
  if (length(nameCheck) > 0) {
  	stop(paste("Mismatch of rownames at file", inFile, sep = " "))
  }
  if (ncol(data) > 0) { return(data[,inCol]) }
  else {return(rep(NA,nrow(data))) }
}

combinedSamples = sapply(as.list(x),readHTS)
#save(collectedSums, file = paste(args$oPrefix, "collectedSums.Robj.gz", sep - "_"), compress = "bzip2")

transNames = sapply(as.list(ENSGnames),function(y){unlist(strsplit(as.character(y), split = "|", fixed = TRUE))[1]})

rownames(combinedSamples) = transNames
colnames(combinedSamples) = samples
head(combinedSamples)
write.table(combinedSamples,file = paste(args$oPrefix, "quant_matrix.txt", sep = "_"), row.names = TRUE, col.names = TRUE, quote = FALSE, sep = "\t")
