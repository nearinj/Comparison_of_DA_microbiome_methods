#### Format_Lefse



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


flip_ASV_table <- data.frame(t(ASV_table), check.names = F)

if(all.equal(rownames(flip_ASV_table), rownames(groupings)) == F){
  stop("Error: Samples do not match up!!! at merging of metadata and ASV table")
}



flip_ASV_table <- cbind(groupings[,1], flip_ASV_table)
colnames(flip_ASV_table)[1] <- "Groupings"
ret_tab <- data.frame(t(flip_ASV_table), check.names = F)

write.table(ret_tab, file=args[3], quote=FALSE, sep="\t", col.names = NA)

message("Lefse formatted table written")
