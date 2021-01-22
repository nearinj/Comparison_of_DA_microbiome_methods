
deps = c("exactRankTests", "nlme", "dplyr", "ggplot2", "compositions")
for (dep in deps){
  if (dep %in% installed.packages()[,"Package"] == FALSE){
    install.packages(dep)
  }
  library(dep, character.only = TRUE)
}

#args[4] will contain path for the ancom code


args <- commandArgs(trailingOnly = TRUE)

if (length(args) <= 3) {
  stop("At least three arguments must be supplied", call.=FALSE)
}

source(args[[4]])

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

if(sample_num != grouping_num){
  message("The number of samples in the ASV table and the groupings table are unequal")
  message("Will remove any samples that are not found in either the ASV table or the groupings table")
}

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

groupings$Sample <- rownames(groupings)

prepro <- feature_table_pre_process(feature_table = ASV_table, meta_data = groupings, sample_var = 'Sample', 
                                    group_var = NULL, out_cut = 0.05, zero_cut = 0.90,
                                    lib_cut = 1000, neg_lb=FALSE)

feature_table <- prepro$feature_table
metadata <- prepro$meta_data
struc_zero <- prepro$structure_zeros

#run ancom
main_var <- colnames(groupings)[1]
p_adj_method = "BH"
alpha=0.1
adj_formula=NULL
rand_formula=NULL
res <- ANCOM(feature_table = feature_table, meta_data = metadata, struc_zero = struc_zero, main_var = main_var, p_adj_method = p_adj_method,
             alpha=alpha, adj_formula = adj_formula, rand_formula = rand_formula)


write.table(res$out, file=args[3], quote=FALSE, sep="\t", col.names = NA)
