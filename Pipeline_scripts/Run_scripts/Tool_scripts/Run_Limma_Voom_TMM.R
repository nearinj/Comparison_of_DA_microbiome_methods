
deps = c("edgeR")
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

DGE_LIST <- DGEList(ASV_table)
### do normalization
### Reference sample will be the sample with the highest read depth

### check if upper quartile method works for selecting reference
Upper_Quartile_norm_test <- calcNormFactors(DGE_LIST, method="upperquartile")

summary_upper_quartile <- summary(Upper_Quartile_norm_test$samples$norm.factors)[3]
if(is.na(summary_upper_quartile)){
  message("Upper Quartile reference selection failed will use find sample with largest sqrt(read_depth) to use as reference")
  Ref_col <- which.max(colSums(sqrt(ASV_table)))
  DGE_LIST_Norm <- calcNormFactors(DGE_LIST, method = "TMM", refColumn = Ref_col)
}else{
  DGE_LIST_Norm <- calcNormFactors(DGE_LIST, method="TMM")
}

## make matrix for testing
colnames(groupings) <- c("comparison")
mm <- model.matrix(~comparison, groupings)

voomvoom <- voom(DGE_LIST_Norm, mm, plot=F)

fit <- lmFit(voomvoom,mm)
fit <- eBayes(fit)
res <- topTable(fit, coef=2, n=nrow(DGE_LIST_Norm), sort.by="none")
write.table(res, file=args[3], quote=F, sep="\t", col.names = NA)

