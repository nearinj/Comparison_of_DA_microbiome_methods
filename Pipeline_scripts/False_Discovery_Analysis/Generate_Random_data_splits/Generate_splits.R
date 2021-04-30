### script that will take

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

# read in rarified table
con2 <- file(args[3])
file_2_line1 <- readLines(con2, n=1)
close(con2)

if(grepl("Constructed from biom file", file_2_line1)){
  Rar_ASV_table <- read.table(args[3], sep="\t", skip=1, header=T, row.names = 1,
                          comment.char = "", quote="", check.names = F)
}else{
  Rar_ASV_table <- read.table(args[3], sep="\t", header=T, row.names = 1,
                          comment.char = "", quote="", check.names = F)
}

### filter rar_asv table so it matches the grouping file.

sample_num <- length(colnames(Rar_ASV_table))
grouping_num <- length(rownames(groupings))

#check if the same number of samples are being input.
if(sample_num != grouping_num){
  message("The number of samples in the ASV table and the groupings table are unequal")
  message("Will remove any samples that are not found in either the ASV table or the groupings table")
}

#check if order of samples match up.
if(identical(colnames(Rar_ASV_table), rownames(groupings))==T){
  message("Groupings and ASV table are in the same order")
}else{
  rows_to_keep <- intersect(colnames(Rar_ASV_table), rownames(groupings))
  groupings <- groupings[rows_to_keep,,drop=F]
  Rar_ASV_table <- Rar_ASV_table[,rows_to_keep]
  if(identical(colnames(Rar_ASV_table), rownames(groupings))==T){
    message("Groupings table was re-arrange to be in the same order as the ASV table")
    message("A total of ", sample_num-length(colnames(Rar_ASV_table)), " from the Rar_ASV_table")
    message("A total of ", grouping_num-length(rownames(groupings)), " from the groupings table")
  }else{
    stop("Unable to match samples between the ASV table and groupings table")
  }
}

# match ASV table to rarified table.
sort_ASV_table <- ASV_table[,colnames(Rar_ASV_table)]

### okay now to the meat

### first we will find which grouping has the largest number of samples

variable <- names(which.max(table(groupings[1])))

filt_groupings <- groupings[which(groupings[1]==variable),,drop=FALSE]
filt_ASV_table <- sort_ASV_table[,rownames(filt_groupings)]
filt_Rar_ASV_table <- Rar_ASV_table[,rownames(filt_groupings)]

## we need to export those tables and now we need to generate 100 random groupings

write_random_grpings <- function(grp_file, num_tabs){
  ### calulate number of samples to be choosen to be grp "ran1"
  n <- round(length(rownames(filt_groupings))/2)

  for(i in 1:num_tabs){
    temp_groupings <- filt_groupings[,,drop=F]
    samps_choosen <- sample(c(1:length(rownames(filt_groupings))), n)
    temp_groupings[1] <- "ran2"
    temp_groupings[samps_choosen,] <- "ran1"
    tab_name <- paste(args[[4]], "/random_table_",i,".tsv",sep="")
    if(i > 10){
        tab_name <- paste(tab_name, "ext", sep="")
    }
    write.table(temp_groupings, file=tab_name, quote=FALSE, sep="\t", col.names = NA)
  }

}

write_random_grpings(filt_groupings, 100)


