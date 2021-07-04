# Separate code to compute PERMANOVA on Aichison's distance between the two sample groups for each tested dataset in Fig 1.

rm(list = ls(all.names = TRUE))

library(parallelDist)
library(vegan)

pseudocount_and_clr <- function(in_df, pseudocount = 1) {
  # Adds pseudocount to all samples and applies centred log-ratio transformation.
  # Note that this functions assumes that columns are samples and rows are features.

  return(as.data.frame(apply(in_df + pseudocount,
                             2,
                             function(x){log(x) - mean(log(x))})))
}

# Read in ASV tables (unfiltered and filtered as well as rarefied or not for each).
unfilt_study_tab  <- readRDS("/home/jacob/GitHub_Repos/Hackathon_testing/Data/unfilt_study_tab_21_04_07.RDS")
filt_study_tab <- readRDS("/home/jacob/GitHub_Repos/Hackathon_testing/Data/filt_study_tab_21_04_07.RDS")

# Read in sample groups for each dataset.
meta_tables <- list()
for (study in names(filt_study_tab$nonrare)) {

  # The metadata table files have various file naming schemes so there are a few to try:
  meta_path1 <- paste("/home/jacob/projects/HACKATHON_ANCOM_FIX_21_03_13/Hackathon/Studies/", study, "/", study, "_meta.tsv", sep = "")
  meta_path2 <- paste("/home/jacob/projects/HACKATHON_ANCOM_FIX_21_03_13/Hackathon/Studies/", study, "/", study, "_metadata.tsv", sep = "")
  meta_path3 <- paste("/home/jacob/projects/HACKATHON_ANCOM_FIX_21_03_13/Hackathon/Studies/", study, "/", study, "_metadata.csv", sep = "")
  
  if (file.exists(meta_path1)) {
    meta_tables[[study]] <- read.table(file = meta_path1, header = TRUE, sep = "\t", row.names = 1, stringsAsFactors = FALSE)
  } else if (file.exists(meta_path2)) {
    meta_tables[[study]] <- read.table(file = meta_path2, header = TRUE, sep = "\t", row.names = 1, stringsAsFactors = FALSE)
  } else if (file.exists(meta_path3)) {
    meta_tables[[study]] <- read.table(file = meta_path3, header = TRUE, sep = "\t", row.names = 1, stringsAsFactors = FALSE)
  } else {
    print(study)
    stop("Metadata file not found.")
  }
}



PERMANOVA_output <- data.frame(matrix(NA, nrow = 38, ncol = 9))
rownames(PERMANOVA_output) <- names(filt_study_tab$nonrare)
colnames(PERMANOVA_output) <- c("dataset",
                                "filt_nonrare_R2", "filt_nonrare_P", "filt_rare_R2", "filt_rare_P",
                                "unfilt_nonrare_R2", "unfilt_nonrare_P", "unfilt_rare_R2", "unfilt_rare_P")
PERMANOVA_output$dataset <- names(filt_study_tab$nonrare)

num_threads <- 30

for (study in names(filt_study_tab$nonrare)) {

  message("Running ", study, " dataset")
  
  unfilt_nonrare_samples <- colnames(unfilt_study_tab$nonrare[[study]])[which(colnames(unfilt_study_tab$nonrare[[study]]) %in% rownames(meta_tables[[study]]))]
  unfilt_nonrare_ASV_aitchison <- parallelDist(x = t(pseudocount_and_clr(unfilt_study_tab$nonrare[[study]][, unfilt_nonrare_samples])), method = "euclidean", threads = num_threads)
  unfilt_nonrare_ASV_aitchison_formula <- as.formula(unfilt_nonrare_ASV_aitchison ~ meta_tables[[study]][unfilt_nonrare_samples, 1])
  unfilt_nonrare_ASV_aitchison_permanova <- data.frame(adonis(formula = unfilt_nonrare_ASV_aitchison_formula, permutations = 999)$aov.tab)
  PERMANOVA_output[study, c("unfilt_nonrare_R2", "unfilt_nonrare_P")] <- as.numeric(unfilt_nonrare_ASV_aitchison_permanova[1, c("R2", "Pr..F.")])
  
  unfilt_rare_samples <- colnames(unfilt_study_tab$rare[[study]])[which(colnames(unfilt_study_tab$rare[[study]]) %in% rownames(meta_tables[[study]]))]
  unfilt_rare_ASV_aitchison <- parallelDist(x = t(pseudocount_and_clr(unfilt_study_tab$rare[[study]][, unfilt_rare_samples])), method = "euclidean", threads = num_threads)
  unfilt_rare_ASV_aitchison_formula <- as.formula(unfilt_rare_ASV_aitchison ~ meta_tables[[study]][unfilt_rare_samples, 1])
  unfilt_rare_ASV_aitchison_permanova <- data.frame(adonis(formula = unfilt_rare_ASV_aitchison_formula, permutations = 999)$aov.tab)
  PERMANOVA_output[study, c("unfilt_rare_R2", "unfilt_rare_P")] <- as.numeric(unfilt_rare_ASV_aitchison_permanova[1, c("R2", "Pr..F.")])

  filt_nonrare_samples <- colnames(filt_study_tab$nonrare[[study]])[which(colnames(filt_study_tab$nonrare[[study]]) %in% rownames(meta_tables[[study]]))]
  filt_nonrare_ASV_aitchison <- parallelDist(x = t(pseudocount_and_clr(filt_study_tab$nonrare[[study]][, filt_nonrare_samples])), method = "euclidean", threads = num_threads)
  filt_nonrare_ASV_aitchison_formula <- as.formula(filt_nonrare_ASV_aitchison ~ meta_tables[[study]][filt_nonrare_samples, 1])
  filt_nonrare_ASV_aitchison_permanova <- data.frame(adonis(formula = filt_nonrare_ASV_aitchison_formula, permutations = 999)$aov.tab)
  PERMANOVA_output[study, c("filt_nonrare_R2", "filt_nonrare_P")] <- as.numeric(filt_nonrare_ASV_aitchison_permanova[1, c("R2", "Pr..F.")])
  
  filt_rare_samples <- colnames(filt_study_tab$rare[[study]])[which(colnames(filt_study_tab$rare[[study]]) %in% rownames(meta_tables[[study]]))]
  filt_rare_ASV_aitchison <- parallelDist(x = t(pseudocount_and_clr(filt_study_tab$rare[[study]][, filt_rare_samples])), method = "euclidean", threads = num_threads)
  filt_rare_ASV_aitchison_formula <- as.formula(filt_rare_ASV_aitchison ~ meta_tables[[study]][filt_rare_samples, 1])
  filt_rare_ASV_aitchison_permanova <- data.frame(adonis(formula = filt_rare_ASV_aitchison_formula, permutations = 999)$aov.tab)
  PERMANOVA_output[study, c("filt_rare_R2", "filt_rare_P")] <- as.numeric(filt_rare_ASV_aitchison_permanova[1, c("R2", "Pr..F.")])
  
}

write.table(x = PERMANOVA_output,
            file = "/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/aitchison_permanova_results.tsv",
            row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
