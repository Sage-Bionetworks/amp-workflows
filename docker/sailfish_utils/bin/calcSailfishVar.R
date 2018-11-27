#!/usr/bin/env Rscript
# Calculate transcript quant variance from Sailfish bootstraps
# KKD for Sage Bionetworks
# 15 Jul 2016

library(data.table)
library(argparse)

parser = ArgumentParser(description='Calculate and collect mean/med/var for boostrapts across dataset.')
parser$add_argument('--oPrefix', type="character", required=TRUE, help='Prefix for output files.')
parser$add_argument('--headF', type = "character", required=TRUE, help='Path to file to use for output headers.')
parser$add_argument('--wd', default = getwd(), type="character", help='Directory of input files [default %(default)s].')
args = parser$parse_args()



newHeader = read.delim(args$headF, header = FALSE)
#newHeader = read.delim("~/Computing/NIA-AMP-AD/reprocessed/transcripts/revised_quant_headers", header = FALSE)
#quantFile = fread(input = "~/Computing/NIA-AMP-AD/reprocessed/transcripts/quant_bootstraps.tsv", header = TRUE)

calcSummary=function(inQuant,nHead=newHeader,toPlot=FALSE){
  print(inQuant)
  bootData = fread(input = inQuant, header = TRUE)
  colnames(bootData) = as.character(nHead[,1])
  test = data.matrix(bootData)
  allVar = apply(X = test,MARGIN = 2,FUN = var)
  allMean = colMeans(test)
  allMedian = apply(X=test,MARGIN = 2,FUN = median)
  if (toPlot==TRUE) {
    hist(log(allVar))
    hist(log(allMean))
    hist(log(allMedian))
  }
  return(list(var=allVar,mean=allMean,median=allMedian))
}


setwd(args$wd)
inDir = dir()
allResults = lapply(as.list(inDir),calcSummary)


matrixVar = sapply(allResults,function(x){x$var})
dim(matrixVar)
colnames(matrixVar) = inDir
write.table(matrixVar,file = paste(oPrefix,"boostrap_var.tsv",sep = "_"),quote = FALSE,sep = "\t",row.names = TRUE,col.names = TRUE)

matrixMean = sapply(allResults,function(x){x$mean})
dim(matrixMean)
colnames(matrixMean) = inDir
write.table(matrixMean,file = paste(oPrefix,"boostrap_mean.tsv",sep = "_"),quote = FALSE,sep = "\t",row.names = TRUE,col.names = TRUE)

matrixMedian = sapply(allResults,function(x){x$median})
dim(matrixMedian)
colnames(matrixMedian) = inDir
write.table(matrixMedian,file = paste(oPrefix,"boostrap_median.tsv",sep = "_"),quote = FALSE,sep = "\t",row.names = TRUE,col.names = TRUE)
