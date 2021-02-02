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


if(!identical(colnames(ASV_table_1), colnames(ASV_table_2))){
  
  if(length(colnames(ASV_table_1)) > length(colnames(ASV_table_2))){
    
    message("There are more samples in the non-rarified table. These samples will be fitlered out before running differential abundance calculations")
    ASV_table_1 <- ASV_table_1[, colnames(ASV_table_2)]
    write.table(ASV_table_1, sep="\t", quote=F, file=args[[3]])
  }
  else{
    
    "The samples do not match in the rarified and non-rarified tables please check the input files"
  }
}else{
  "Samples  between tables agree, no filtering required"
  write.table(ASV_table_1, sep="\t", quote=F, file=args[[3]])
}
### filer ASV_table_1 to be the same

