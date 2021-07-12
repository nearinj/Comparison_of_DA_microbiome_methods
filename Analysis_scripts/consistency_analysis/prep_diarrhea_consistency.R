### Commands to process diarrhea datasets for consistency analysis.
### This includes reading in the data, formatting it to be the same across all studies,
### and generating consistency distributions expected by chance for each tool.
### These final files are then output as RDS objects to be used for downstream plotting.

### Author: Gavin Douglas

rm(list = ls(all.names = TRUE))

setwd("/home/jacob/projects/HACKATHON_ANCOM_FIX_21_03_13/Hackathon/Testing_Bias_robustness/Diarrhea/")

source("/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Analysis_scripts/consistency_analysis/consistency_functions.R")

# Read in tool outputs at the genus level for the diarrhea studies.
diarrhea_studies <- list.files(".")
diarrhea_outputs <- list()

for (study in diarrhea_studies) {
  diarrhea_outputs[[study]] <- read_genera_hackathon_results(study, results_folder = "Genus_filt")
}


# Fix genera labels, including stripping full taxonomy from Duvallet datasets.
# Also, Lefse converted several genera names to the wrong format.
fixed_lefse_ids <- read.table("/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/mapfiles/diarrhea_lefse_misformatted_ids.txt",
                              header = TRUE, sep = "\t", stringsAsFactors = FALSE)

fixed_lefse_ids <- fixed_lefse_ids[-which(duplicated(fixed_lefse_ids$raw)), ]
fixed_lefse_ids <- fixed_lefse_ids[-which(is.na(fixed_lefse_ids$raw)), ]

fixed_lefse_ids$fixed <- gsub("UCG_", "UCG-", fixed_lefse_ids$fixed)

rownames(fixed_lefse_ids) <- fixed_lefse_ids$raw

dia_schneider_old_ids <- rownames(diarrhea_outputs$dia_schneider$adjP_table)[which(rownames(diarrhea_outputs$dia_schneider$adjP_table) %in% fixed_lefse_ids$raw)]
dia_schneider_new_ids <- fixed_lefse_ids[dia_schneider_old_ids, "fixed"]
diarrhea_outputs$dia_schneider$adjP_table[dia_schneider_new_ids, "lefse"] <- diarrhea_outputs$dia_schneider$adjP_table[dia_schneider_old_ids, "lefse"]
diarrhea_outputs$dia_schneider$adjP_table <- diarrhea_outputs$dia_schneider$adjP_table[-which(rownames(diarrhea_outputs$dia_schneider$adjP_table) %in% dia_schneider_old_ids), ]
rownames(diarrhea_outputs$dia_schneider$adjP_table)[which(rownames(diarrhea_outputs$dia_schneider$adjP_table) ==  "Clostridium sensu stricto 1")] <- "Clostridium sensu stricto"
rownames(diarrhea_outputs$dia_schneider$adjP_table) <- gsub(" ", "_", rownames(diarrhea_outputs$dia_schneider$adjP_table))


GEMS1_old_ids <- rownames(diarrhea_outputs$GEMS1$adjP_table)[which(rownames(diarrhea_outputs$GEMS1$adjP_table) %in% fixed_lefse_ids$raw)]
GEMS1_new_ids <- fixed_lefse_ids[GEMS1_old_ids, "fixed"]
diarrhea_outputs$GEMS1$adjP_table[GEMS1_new_ids, "lefse"] <- diarrhea_outputs$GEMS1$adjP_table[GEMS1_old_ids, "lefse"]
diarrhea_outputs$GEMS1$adjP_table <- diarrhea_outputs$GEMS1$adjP_table[-which(rownames(diarrhea_outputs$GEMS1$adjP_table) %in% GEMS1_old_ids), ]
rownames(diarrhea_outputs$GEMS1$adjP_table)[which(rownames(diarrhea_outputs$GEMS1$adjP_table) ==  "Clostridium sensu stricto 1")] <- "Clostridium sensu stricto"
rownames(diarrhea_outputs$GEMS1$adjP_table) <- gsub(" ", "_", rownames(diarrhea_outputs$GEMS1$adjP_table))


# Also converted from long to genus form
cdi_schubert_genera <- rownames(diarrhea_outputs$cdi_schubert$adjP_table)
cdi_schubert_genera <- gsub("k__.*g__", "", cdi_schubert_genera)
cdi_schubert_genera_remove_i <- which(cdi_schubert_genera ==  "")
diarrhea_outputs$cdi_schubert$adjP_table <- diarrhea_outputs$cdi_schubert$adjP_table[-cdi_schubert_genera_remove_i, ]
rownames(diarrhea_outputs$cdi_schubert$adjP_table) <- cdi_schubert_genera[-cdi_schubert_genera_remove_i]

cdi_vincent_genera <- rownames(diarrhea_outputs$cdi_vincent$adjP_table)
cdi_vincent_genera <- gsub("k__.*g__", "", cdi_vincent_genera)
cdi_vincent_genera_remove_i <- which(cdi_vincent_genera ==  "")
diarrhea_outputs$cdi_vincent$adjP_table <- diarrhea_outputs$cdi_vincent$adjP_table[-cdi_vincent_genera_remove_i, ]
rownames(diarrhea_outputs$cdi_vincent$adjP_table) <- cdi_vincent_genera[-cdi_vincent_genera_remove_i]

edd_singh_genera <- rownames(diarrhea_outputs$edd_singh$adjP_table)
edd_singh_genera <- gsub("k__.*g__", "", edd_singh_genera)
edd_singh_genera_remove_i <- which(edd_singh_genera ==  "")
diarrhea_outputs$edd_singh$adjP_table <- diarrhea_outputs$edd_singh$adjP_table[-edd_singh_genera_remove_i, ]
rownames(diarrhea_outputs$edd_singh$adjP_table) <- edd_singh_genera[-edd_singh_genera_remove_i]


# Convert P-value tables to binary: 0 for non-significant (or NA) and 1 for significant, respectively.
diarrhea_outputs_binary <- list()

for (study in diarrhea_studies) {

  diarrhea_outputs_binary[[study]] <- diarrhea_outputs[[study]]$adjP_table
  
  diarrhea_outputs_binary[[study]][diarrhea_outputs[[study]]$adjP_table >=  0.05] <- 0
  diarrhea_outputs_binary[[study]][diarrhea_outputs[[study]]$adjP_table < 0.05] <- 1 
  diarrhea_outputs_binary[[study]][is.na(diarrhea_outputs_binary[[study]])] <- 0
}
  
# Sanity check on a few comparisons
identical(which(diarrhea_outputs_binary$baxter$aldex2 ==  1),
  which(diarrhea_outputs$baxter$adjP_table$aldex2 < 0.05))

identical(which(diarrhea_outputs_binary$schubert$lefse ==  1),
  which(diarrhea_outputs$schubert$adjP_table$lefse < 0.05))

identical(which(diarrhea_outputs_binary$zupancic$edger ==  1),
  which(diarrhea_outputs$zupancic$adjP_table$edger < 0.05))


# Next, needed to make a single table of these binary values for all tools and datasets.
# To do this the overlapping genera need to be found and a list of all other genera as well.
# In other words, get the union of all genera across studies.
# Also, remove all incertae sedis genera.

genera_union <- c()

for (study in names(diarrhea_outputs_binary)) {
  genera_union <- c(genera_union, rownames(diarrhea_outputs_binary[[study]]))
  duplicated_genera <- which(duplicated(genera_union))
  
  if (length(duplicated_genera) > 0) {
    genera_union <- genera_union[-duplicated_genera]
  }
}

genera_union_filt <- genera_union[-grep("incertae_sedis$", genera_union)]


# Now created a combined table of which genera were significant with each tool / study.

# First need to add in genera missing in individual studies. Also sort genera (rownames) to be in same order for each dataset.
diarrhea_outputs_binary_clean <- diarrhea_outputs_binary

for (study in names(diarrhea_outputs_binary_clean)) {
  missing_genera <- genera_union_filt[which(!genera_union_filt %in% rownames(diarrhea_outputs_binary_clean[[study]]))]

  if (length(missing_genera > 0)) {
    diarrhea_outputs_binary_clean[[study]][missing_genera, ] <- 0
  }

  # Restrict and order genera to analyze
  diarrhea_outputs_binary_clean[[study]] <- diarrhea_outputs_binary_clean[[study]][genera_union_filt, ]
}
  
# Now create combined table.
# Note that cbind will automatically prefix each column with the study name
diarrhea_outputs_binary_clean_combined <- do.call(cbind, diarrhea_outputs_binary_clean)


# Generate the expected overlap across studies for each tool simply based on the
# same number of significant hits for each tool/study if they were randomly distributed.

diarrhea_outputs_binary_clean_summed <- diarrhea_outputs_binary_clean[["cdi_schubert"]]  

for (study in diarrhea_studies) {
  
  if (study ==  "cdi_schubert") { next }
  
  diarrhea_outputs_binary_clean_summed <- diarrhea_outputs_binary_clean_summed + diarrhea_outputs_binary_clean[[study]]
  
}

tool_sampling_p <- list()
  
num_rep <- 1000 * nrow(diarrhea_outputs_binary_clean_summed)
tool_samplings <- data.frame(matrix(0, nrow = num_rep, ncol = ncol(diarrhea_outputs_binary_clean_summed)))
colnames(tool_samplings) <- colnames(diarrhea_outputs_binary_clean_summed)
  
for (tool in colnames(diarrhea_outputs_binary_clean_summed)) {

  tool_sampling_p[[tool]] <- c()

  for (study in diarrhea_studies) {
  
    sampling_prob <- sum(diarrhea_outputs_binary_clean[[study]][, tool]) / nrow(diarrhea_outputs_binary_clean[[study]])

    if (sampling_prob !=  0) {
      tool_sampling_p[[tool]] <- c(tool_sampling_p[[tool]], sampling_prob)
    }

  }

  for (i in 1:num_rep) {
  
    rep_sampling <- c()
  
    for (j in 1:length(tool_sampling_p[[tool]])) {
      rep_sampling <- c(rep_sampling, sample(c(0, 1), prob = c(1 - tool_sampling_p[[tool]][j], tool_sampling_p[[tool]][j]), size = 1))
    }
  
    num_sampled <- sum(rep_sampling)
  
    tool_samplings[i, tool] <- num_sampled

  }
  
}

# Put null dists and actual dists in same dataframes to plot and test for statistical differences

combined_overlap <- tool_samplings

colnames(combined_overlap) <- paste(colnames(combined_overlap), "expected", sep = ".")

obs_names <- paste(colnames(diarrhea_outputs_binary_clean_summed), "observed", sep = ".")

combined_overlap[, obs_names] <- NA

for (tool in colnames(diarrhea_outputs_binary_clean_summed)) {
  obs_name <- paste(tool, "observed", sep = ".")
  combined_overlap[1:nrow(diarrhea_outputs_binary_clean_summed), obs_name] <- diarrhea_outputs_binary_clean_summed[, tool]
}

combined_overlap <- combined_overlap[, sort(colnames(combined_overlap))]

# Save key prepped tables.
saveRDS(object = diarrhea_outputs_binary_clean_combined,
        file = "/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/consistency_analysis_RDS_out/diarrhea_outputs_binary_clean_combined.rds")

saveRDS(object = combined_overlap,
        file = "/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/consistency_analysis_RDS_out/diarrhea_combined_overlap.rds")
