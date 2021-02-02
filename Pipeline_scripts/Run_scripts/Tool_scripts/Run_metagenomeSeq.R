deps = c("metagenomeSeq")
for (dep in deps){
  if (dep %in% installed.packages()[,"Package"] == FALSE){
    if (!requireNamespace("BiocManager", quietly = TRUE))
      install.packages("BdepManager")
    
    BiocManager::install(deps)
  }
  library(dep, character.only = TRUE)
}

args <- commandArgs(trailingOnly = TRUE)
#test if there is an argument supply
if (length(args) <= 2) {
  stop("At least three arguments must be supplied", call.=FALSE)
}

con <- file(args[1])
file_1_line1 <- readLines(con,n=1)
close(con)

if(grepl("Constructed from biom file", file_1_line1)){
  ASV_table <- read.table(args[1], sep="\t", skip=1, header=T, row.names = 1, 
                          comment.char = "", quote="", check.names = F)
}else{
  ASV_table <- read.table(args[1], sep="\t", header=T, row.names = 1, 
                          comment.char = "", quote="", check.names = F)
}

groupings <- read.table(args[2], sep="\t", row.names = 1, header=T, comment.char = "", quote="", check.names = F)

#number of samples
sample_num <- length(colnames(ASV_table))
grouping_num <- length(rownames(groupings))

#check if the same number of samples are being input.
if(sample_num != grouping_num){
  message("The number of samples in the ASV table and the groupings table are unequal")
  message("Will remove any samples that are not found in either the ASV table or the groupings table")
}

#check if order of samples match up.
if(identical(colnames(ASV_table), rownames(groupings))==T){
  message("Groupings and ASV table are in the same order")
}else{
  rows_to_keep <- intersect(colnames(ASV_table), rownames(groupings))
  groupings <- groupings[rows_to_keep,,drop=F]
  ASV_table <- ASV_table[,rows_to_keep]
  if(identical(colnames(ASV_table), rownames(groupings))==T){
    message("Groupings table was re-arrange to be in the same order as the ASV table")
    message("A total of ", sample_num-length(colnames(ASV_table)), " from the ASV_table")
    message("A total of ", grouping_num-length(rownames(groupings)), " from the groupings table")
  }else{
    stop("Unable to match samples between the ASV table and groupings table")
  }
}

data_list <- list()
data_list[["counts"]] <- ASV_table
data_list[["taxa"]] <- rownames(ASV_table)

pheno <- AnnotatedDataFrame(groupings)
pheno
counts <- AnnotatedDataFrame(ASV_table)
feature_data <- data.frame("ASV"=rownames(ASV_table),
                           "ASV2"=rownames(ASV_table))
feature_data <- AnnotatedDataFrame(feature_data)
rownames(feature_data) <- feature_data@data$ASV


test_obj <- newMRexperiment(counts = data_list$counts, phenoData = pheno, featureData = feature_data)

p <- cumNormStat(test_obj, pFlag = T)
p

test_obj_norm <- cumNorm(test_obj, p=p)

fromula <- as.formula(paste(~1, colnames(groupings)[1], sep=" + "))
pd <- pData(test_obj_norm)
mod <- model.matrix(fromula, data=pd)
regres <- fitFeatureModel(test_obj_norm, mod)

res_table <- MRfulltable(regres, number = length(rownames(ASV_table)))

write.table(res_table, file=args[3], quote=F, sep="\t", col.names = NA)
