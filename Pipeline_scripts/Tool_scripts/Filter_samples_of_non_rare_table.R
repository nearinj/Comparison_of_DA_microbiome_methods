#### Check if rarified and non-rarified tables contain the same samples and if they don't create a table that does



args <- commandArgs(trailingOnly = TRUE)
#test if there is an argument supply
if (length(args) <= 2) {
  stop("At least three arguments must be supplied", call.=FALSE)
}

### check if we need to skip first line of file
con <- file(args[1])
file_1_line1 <- readLines(con,n=1)
close(con)

if(grepl("Constructed from biom file", file_1_line1)){
  ASV_table_1 <- read.table(args[1], sep="\t", skip=1, header=T, row.names = 1, 
                            comment.char = "", quote="", check.names = F)
}else{
  ASV_table_1 <- read.table(args[1], sep="\t", header=T, row.names = 1, 
                            comment.char = "", quote="", check.names = F)
}
if("taxonomy" %in% colnames(ASV_table_1)){
  ASV_table_1 <- subset(ASV_table_1, select=-c(taxonomy))
}


con2 <- file(args[[2]])
file_2_line1 <- readLines(con2, n=1)
close(con2)

if(grepl("Constructed from biom file", file_2_line1)){
  ASV_table_2 <- read.table(args[2], sep="\t", skip=1, header=T, row.names = 1, 
                            comment.char = "", quote="", check.names = F)
}else{
  ASV_table_2 <- read.table(args[2], sep="\t", header=T, row.names = 1, 
                            comment.char = "", quote="", check.names = F)
}

if("taxonomy" %in% colnames(ASV_table_2)){
  ASV_table_2 <- subset(ASV_table_2, select=-c(taxonomy))
}


## in this set up we read both tables in
## we then need to first double check the ASV_table_2 against the metadata
## techiically to run the unfiltered data we could just input 0 into 
## the remove_rare_features.... this would centralize the way the pipeline is run
## and we can output a fixed ASV table easily... the only issue would be that
## we would need to include a seed to make it reproducible... 
## hmmm

## I think for now to save time we will just continue as is but we can discuss
## this in the feature.

## read in the metadata
groupings <- read.table(args[4], sep="\t", row.names = 1, header=T, comment.char = "", quote="", check.names = F)
# in some cases metadata will be smaller than the ASV table so we take intersect
samps_keep <- intersect(colnames(ASV_table_2), rownames(groupings))
ASV_table_2 <- ASV_table_2[,samps_keep]
## this makes it so we only keep samples in the table we are interested in comparing

### we need to remove rows (ASVs) that have a sum of 0 across all samples
remove_rows <- which(rowSums(ASV_table_2)==0)

if(length(remove_rows) != 0){
  ASV_table_2 <- ASV_table_2[-remove_rows,]
}



if(!identical(colnames(ASV_table_1), colnames(ASV_table_2))){
  
  if(length(colnames(ASV_table_1)) > length(colnames(ASV_table_2))){
    
    message("There are more samples in the non-rarified table. These samples will be fitlered out before running differential abundance calculations")
    ASV_table_1 <- ASV_table_1[, colnames(ASV_table_2)]
    
    #fix issue 1 by making sure there are no rowSums equal to 0 in the non-rare table.
    remove_rows_zero <- which(rowSums(ASV_table_1)==0)
    if(length(remove_rows_zero) != 0){
      ASV_table_1 <- ASV_table_1[-remove_rows_zero,]
    }
    write.table(ASV_table_1, sep="\t", quote=F, file=args[[3]])
    write.table(ASV_table_2, sep="\t", quote=F, file=args[[5]])
  }
  else{
    
    "The samples do not match in the rarified and non-rarified tables please check the input files"
  }
}else{
  "Samples  between tables agree, no filtering required"
  #fix issue 1 by making sure there are no rowSums equal to 0 in the non-rare table.
  remove_rows_zero <- which(rowSums(ASV_table_1)==0)
  if(length(remove_rows_zero) != 0){
    ASV_table_1 <- ASV_table_1[-remove_rows_zero,]
  }
  write.table(ASV_table_1, sep="\t", quote=F, file=args[[3]])
  write.table(ASV_table_2, sep="\t", quote=F, file=args[[5]])
}
### filer ASV_table_1 to be the same

