### Commands to process obesity datasets for consistency analysis.
### This includes reading in the data, formatting it to be the same across all studies,
### and generating consistency distributions expected by chance for each tool.
### These final files are then output as RDS objects to be used for downstream plotting.

rm(list = ls(all.names = TRUE))

setwd("/home/jacob/projects/HACKATHON_ANCOM_FIX_21_03_13/Hackathon/Testing_Bias_robustness/Obesity/")

source("/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Analysis_scripts/consistency_analysis/consistency_functions.R")

# Read in tool outputs at the genus level for the obesity studies.
# Note that this is limited to just five studies
# because there were issues with the genera names for the others.
obesity_studies <- c("goodrich", "ross", "turnbaugh", "zhu", "zupancic")
obesity_outputs <- list()

for (study in obesity_studies) {
  obesity_outputs[[study]] <- read_genera_hackathon_results(study, results_folder = "Genus_filt")
}


# Convert P-value tables to binary: 0 for non-significant (or NA) and 1 for significant, respectively.
obesity_outputs_binary <- list()

for (study in obesity_studies) {

  obesity_outputs_binary[[study]] <- obesity_outputs[[study]]$adjP_table
  
  obesity_outputs_binary[[study]][obesity_outputs[[study]]$adjP_table >=  0.05] <- 0
  obesity_outputs_binary[[study]][obesity_outputs[[study]]$adjP_table < 0.05] <- 1 
  obesity_outputs_binary[[study]][is.na(obesity_outputs_binary[[study]])] <- 0
}
  
# Sanity check on a few comparisons
identical(which(obesity_outputs_binary$baxter$aldex2 ==  1),
  which(obesity_outputs$baxter$adjP_table$aldex2 < 0.05))

identical(which(obesity_outputs_binary$schubert$lefse ==  1),
  which(obesity_outputs$schubert$adjP_table$lefse < 0.05))

identical(which(obesity_outputs_binary$zupancic$edger ==  1),
  which(obesity_outputs$zupancic$adjP_table$edger < 0.05))


# Next, needed to make a single table of these binary values for all tools and datasets.
# To do this the overlapping genera need to be found and a list of all other genera as well.
# In other words, get the union of all genera across studies.
# Also, remove all unclassified and incertae sedis genera.

genera_union <- c()

for(study in names(obesity_outputs_binary)) {
  genera_union <- c(genera_union, rownames(obesity_outputs_binary[[study]]))
  duplicated_genera <- which(duplicated(genera_union))
  
  if(length(duplicated_genera) > 0) {
    genera_union <- genera_union[-duplicated_genera]
  }
}

genera_union_filt <- genera_union[-grep("g__$", genera_union)]
genera_union_filt <- genera_union_filt[-grep("incertae_sedis$", genera_union_filt)]


# Now created a combined table of which genera were significant with each tool / study.

# First need to add in genera missing in individual studies. Also sort genera (rownames) to be in same order for each dataset.
obesity_outputs_binary_clean <- obesity_outputs_binary

for(study in names(obesity_outputs_binary_clean)) {
  missing_genera <- genera_union_filt[which(! genera_union_filt %in% rownames(obesity_outputs_binary_clean[[study]]))]

  if(length(missing_genera > 0)) {
    obesity_outputs_binary_clean[[study]][missing_genera, ] <- 0
  }

  # Restrict and order genera to analyze
  obesity_outputs_binary_clean[[study]] <- obesity_outputs_binary_clean[[study]][genera_union_filt, ]
}
  
# Now create combined table.
# Note that cbind will automatically prefix each column with the study name
obesity_outputs_binary_clean_combined <- do.call(cbind, obesity_outputs_binary_clean)


# Generate the expected overlap across studies for each tool simply based on the
# same number of significant hits for each tool/study if they were randomly distributed.

obesity_outputs_binary_clean_summed <- obesity_outputs_binary_clean[["goodrich"]]  

for(study in obesity_studies) {
  
  if(study ==  "goodrich") { next }
  
  obesity_outputs_binary_clean_summed <- obesity_outputs_binary_clean_summed + obesity_outputs_binary_clean[[study]]
  
}

tool_sampling_p <- list()
  
num_rep <- 1000 * 116
tool_samplings <- data.frame(matrix(0, nrow = num_rep, ncol = ncol(obesity_outputs_binary_clean_summed)))
colnames(tool_samplings) <- colnames(obesity_outputs_binary_clean_summed)
  
for(tool in colnames(obesity_outputs_binary_clean_summed)) {

  tool_sampling_p[[tool]] <- c()

  for(study in obesity_studies) {
  
    sampling_prob <- sum(obesity_outputs_binary_clean[[study]][, tool]) / nrow(obesity_outputs_binary_clean[[study]])

    if(sampling_prob !=  0) {
      tool_sampling_p[[tool]] <- c(tool_sampling_p[[tool]], sampling_prob)
    }

  }

  for(i in 1:num_rep) {
  
    rep_sampling <- c()
  
    for(j in 1:length(tool_sampling_p[[tool]])) {
      rep_sampling <- c(rep_sampling, sample(c(0, 1), prob = c(1 - tool_sampling_p[[tool]][j], tool_sampling_p[[tool]][j]), size = 1))
    }
  
    num_sampled <- sum(rep_sampling)
  
    tool_samplings[i, tool] <- num_sampled

  }
  
}

# Put null dists and actual dists in same dataframes to plot and test for statistical differences

combined_overlap <- tool_samplings

colnames(combined_overlap) <- paste(colnames(combined_overlap), "expected", sep = ".")

obs_names <- paste(colnames(obesity_outputs_binary_clean_summed), "observed", sep = ".")

combined_overlap[, obs_names] <- NA

for(tool in colnames(obesity_outputs_binary_clean_summed)) {
  obs_name <- paste(tool, "observed", sep = ".")
  combined_overlap[1:nrow(obesity_outputs_binary_clean_summed), obs_name] <- obesity_outputs_binary_clean_summed[, tool]
}

combined_overlap <- combined_overlap[, sort(colnames(combined_overlap))]


# Save key prepped tables.
saveRDS(object = obesity_outputs_binary_clean_combined,
        file = "/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/consistency_analysis_RDS_out/obesity_outputs_binary_clean_combined.rds")

saveRDS(object = combined_overlap,
        file = "/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/consistency_analysis_RDS_out/obesity_combined_overlap.rds")


