### Code to investigate major outliers in unfiltered Wilcoxon CLR FDR analysis.
### Written by Gavin

rm(list = ls(all.names = TRUE))

setwd("/home/jacob/projects/HACKATHON_ANCOM_FIX_21_03_13/Hackathon/Studies/")

# Taken from https://stackoverflow.com/questions/2602583/geometric-mean-is-there-a-built-in
geometric_mean_w_pseudocount = function(x, na.rm = TRUE){
  exp(sum(log(x + 1), na.rm = na.rm) / length(x))
}

datasets_w_outliers <- c("Office", "ArcticFreshwaters", "cdi_schubert", "Blueberry")

wilcoxon_clr_fdr_summary <- list()

for (dataset in datasets_w_outliers) {
  
  wilcoxon_clr_fdr_summary[[dataset]] <- data.frame(matrix(NA, nrow = 100, ncol = 4))

  colnames(wilcoxon_clr_fdr_summary[[dataset]]) <- c("num_sig", "prop_sig", "mean_gm_ratio", "mean_depth_ratio")

  abun_tab_nonrare_path <- paste(dataset,
                                 "/No_filt_Results/fixed_non_rare_tables/",
                                 dataset,
                                 "_ASVs_table.tsv",
                                 sep = "")
  
  abun_tab_nonrare <- read.table(abun_tab_nonrare_path,
                                 header = TRUE, sep = "\t", row.names = 1,
                                 stringsAsFactors = FALSE, 
                                 comment.char = "", check.names = FALSE)
  
  abun_dataset_geometric_means <- sapply(abun_tab_nonrare, geometric_mean_w_pseudocount)
  abun_dataset_colSums <- colSums(abun_tab_nonrare)
  
  # The files containing the groupings are actually misnamed - they are sorted alphabetically rather than numerically.
  path_to_groupings = paste(dataset, "/False_Discovery_Testing/nonfilt_tabs/", sep = "")
  files_to_read <- list.files(path = path_to_groupings, pattern = "*.tsv$", full.names = TRUE)
  files_to_read_ext <- list.files(path = path_to_groupings, pattern = "*.tsvext", full.names = TRUE)
  files_to_read <- c(files_to_read, files_to_read_ext)
  
  for (rep_num in 1:100) {
  
    rep_num_as.char <- as.character(rep_num)

    if (rep_num <= 10) {
      wilcoxon_clr_rep_out_path <- paste(dataset,
                                         "False_Discovery_Testing/results_nonfilt",
                                         rep_num_as.char,
                                         "Wilcoxon_CLR_out/Wil_CLR_results.tsv",
                                         sep = "/")
    } else {
      wilcoxon_clr_rep_out_path <- paste(dataset,
                                         "False_Discovery_Testing/results_nonfilt_ext",
                                         as.character(rep_num - 10),
                                         "Wilcoxon_CLR_out/Wil_CLR_results.tsv",
                                         sep = "/")
    }
    
    wilcoxon_clr_rep_out <- read.table(wilcoxon_clr_rep_out_path,
                                       header = TRUE, sep = "\t", row.names = 1)

    wilcoxon_clr_rep_out$fdr <- p.adjust(wilcoxon_clr_rep_out$x, "fdr")
    
    rep_num_sig <- length(which(wilcoxon_clr_rep_out$fdr < 0.05))
    rep_prop_sig <- rep_num_sig / nrow(wilcoxon_clr_rep_out)
    
    rep_ran_groups <- read.table(files_to_read[rep_num], header = TRUE, sep = "\t", row.names = 1, stringsAsFactors = FALSE)
    rep_ran_group1 <- rownames(rep_ran_groups)[which(rep_ran_groups[, 1] == "ran1")]
    rep_ran_group2 <- rownames(rep_ran_groups)[which(rep_ran_groups[, 1] == "ran2")]
    
    rep_ran_group1_mean_gm <- mean(abun_dataset_geometric_means[rep_ran_group1])
    rep_ran_group2_mean_gm <- mean(abun_dataset_geometric_means[rep_ran_group2])
    
    rep_ran_group1_mean_depth <- mean(abun_dataset_colSums[rep_ran_group1])
    rep_ran_group2_mean_depth <- mean(abun_dataset_colSums[rep_ran_group2])
  
    if (rep_ran_group1_mean_gm >= rep_ran_group2_mean_gm) {
      mean_gm_ratio <- rep_ran_group1_mean_gm / rep_ran_group2_mean_gm
    } else if (rep_ran_group1_mean_gm < rep_ran_group2_mean_gm) {
      mean_gm_ratio <- rep_ran_group2_mean_gm / rep_ran_group1_mean_gm
    }
    
    if (rep_ran_group1_mean_depth >= rep_ran_group2_mean_depth) {
      mean_depth_ratio <- rep_ran_group1_mean_depth / rep_ran_group2_mean_depth
    } else if (rep_ran_group1_mean_depth < rep_ran_group2_mean_depth) {
      mean_depth_ratio <- rep_ran_group2_mean_depth / rep_ran_group1_mean_depth
    }
    
    wilcoxon_clr_fdr_summary[[dataset]][rep_num, ] <- c(rep_num_sig, rep_prop_sig, mean_gm_ratio, mean_depth_ratio)
    
  }

}

wilcoxon_clr_fdr_summary$ArcticFreshwaters$above_30 <- FALSE
wilcoxon_clr_fdr_summary$Office$above_30 <- FALSE
wilcoxon_clr_fdr_summary$cdi_schubert$above_30 <- FALSE
wilcoxon_clr_fdr_summary$Blueberry$above_30 <- FALSE

# Note that I needed to use a lower cut-off to get the same sample numbers as shown in the existing supp figure - I'm thinking that 30% wasn't the cut-off used?
wilcoxon_clr_fdr_summary$ArcticFreshwaters$above_30[which(wilcoxon_clr_fdr_summary$ArcticFreshwaters$prop_sig > 0.2)] <- TRUE
wilcoxon_clr_fdr_summary$Office$above_30[which(wilcoxon_clr_fdr_summary$Office$prop_sig > 0.2)] <- TRUE
wilcoxon_clr_fdr_summary$cdi_schubert$above_30[which(wilcoxon_clr_fdr_summary$cdi_schubert$prop_sig > 0.2)] <- TRUE
wilcoxon_clr_fdr_summary$Blueberry$above_30[which(wilcoxon_clr_fdr_summary$Blueberry$prop_sig > 0.2)] <- TRUE

# Take a look at ratios of depth vs geometric means
par(mfrow = c(2, 2))
plot(wilcoxon_clr_fdr_summary$ArcticFreshwaters$mean_depth_ratio, wilcoxon_clr_fdr_summary$ArcticFreshwaters$mean_gm_ratio, col = as.factor(wilcoxon_clr_fdr_summary$ArcticFreshwaters$above_30))
plot(wilcoxon_clr_fdr_summary$Office$mean_depth_ratio, wilcoxon_clr_fdr_summary$Office$mean_gm_ratio, col = as.factor(wilcoxon_clr_fdr_summary$Office$above_30))
plot(wilcoxon_clr_fdr_summary$cdi_schubert$mean_depth_ratio, wilcoxon_clr_fdr_summary$cdi_schubert$mean_gm_ratio, col = as.factor(wilcoxon_clr_fdr_summary$cdi_schubert$above_30))
plot(wilcoxon_clr_fdr_summary$Blueberry$mean_depth_ratio, wilcoxon_clr_fdr_summary$Blueberry$mean_gm_ratio, col = as.factor(wilcoxon_clr_fdr_summary$Blueberry$above_30))

### Used these plots as evidence for statements regarding that outliers tend to have the most extreme geometric means as well.
