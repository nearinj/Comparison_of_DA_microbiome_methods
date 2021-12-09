# Supplemental plot to summarize chimera results

rm(list = ls(all.names = TRUE))

library(cowplot)
library(ggplot2)
library(reshape2)

display_items_out <- "/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Display_items//"

setwd("/home/jacob/projects/HACKATHON_ANCOM_FIX_21_03_13/Hackathon/Studies/")

unfilt_results <- readRDS("/home/jacob/GitHub_Repos/Hackathon_testing/Data/Unfilt_results_21_04_07.RDS")
unfilt_study_tab  <- readRDS("/home/jacob/GitHub_Repos/Hackathon_testing/Data/unfilt_study_tab_21_04_07.RDS")

filt_results <- readRDS("/home/jacob/GitHub_Repos/Hackathon_testing/Data/Filt_results_21_04_07.RDS")
filt_study_tab  <- readRDS("/home/jacob/GitHub_Repos/Hackathon_testing/Data/filt_study_tab_21_04_07.RDS")

chimera_percents <- read.table("/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/uchime_ref_chimera_parsing/uchime_ref_chimera_percents.tsv",
                             header = TRUE, sep = "\t", row.names = 1)

study_name_mapfile <- read.table("/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/mapfiles/dataset_name_mapping.csv",
                                 header = TRUE, sep = ",", stringsAsFactors = FALSE, row.names = 1)

tool_name_mapfile <- read.table("/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/mapfiles/tool_name_mapping.csv",
                                 header = TRUE, sep = ",", stringsAsFactors = FALSE, row.names = 1)


# Save chimera %'s to file in plotting data folder (i.e., convert to csv).
chimera_percents_csv <- chimera_percents
chimera_percents_csv$dataset <- rownames(chimera_percents_csv)
chimera_percents_csv <- chimera_percents_csv[, c("dataset", "unfilt_nonrare", "filt_nonrare")]
colnames(chimera_percents_csv) <- c("Dataset", "Unfiltered", "Filtered")
write.table(x = chimera_percents_csv,
            file = "/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Plotting_data/Supp_figures/Supp_Fig2A_chimera_percents.csv",
            sep = ",", row.names = FALSE, col.names = TRUE, quote = FALSE)

# Get significant ASVs
sig_counts <- data.frame(matrix(NA,
                                nrow=length(names(unfilt_results)),
                                ncol=ncol(unfilt_results[[1]]$adjP_table) + 1))
rownames(sig_counts) <- names(unfilt_results)
colnames(sig_counts) <- c("dataset", colnames(unfilt_results[[1]]$adjP_table))
sig_counts$dataset <- rownames(sig_counts)

unfilt_sig_counts <- sig_counts
unfilt_sig_percent <- sig_counts

for(study in rownames(unfilt_sig_counts)) {
  for(tool_name in colnames(unfilt_sig_counts)) {
    
    if(tool_name == "dataset") { next }
    
    if(! tool_name %in% colnames(unfilt_results[[study]]$adjP_table)) {
      unfilt_sig_counts[study, tool_name] <- NA
      unfilt_sig_percent[study, tool_name] <- NA
      next
    }
    
    unfilt_sig_counts[study, tool_name] <- length(which(unfilt_results[[study]]$adjP_table[, tool_name] < 0.05))
    
    # For rarified pipelines get total # ASVs from wilcoxonrare and for non-rarified get it from wilcoxonclr table.
    if(tool_name %in% c("lefse", "maaslin2rare", "ttestrare", "wilcoxonrare")) {
      unfilt_sig_percent[study, tool_name] <- (length(which(unfilt_results[[study]]$adjP_table[, tool_name] < 0.05)) / dim(unfilt_study_tab[["rare"]][[study]])[1]) * 100
    } else {
      unfilt_sig_percent[study, tool_name] <- (length(which(unfilt_results[[study]]$adjP_table[, tool_name] < 0.05)) / dim(unfilt_study_tab[["nonrare"]][[study]])[1]) * 100
    }
  }
}


filt_sig_counts <- sig_counts
filt_sig_percent <- sig_counts

for(study in rownames(filt_sig_counts)) {
  for(tool_name in colnames(filt_sig_counts)) {
    
    if(tool_name == "dataset") { next }
    
    if(! tool_name %in% colnames(filt_results[[study]]$adjP_table)) {
      filt_sig_counts[study, tool_name] <- NA
      filt_sig_percent[study, tool_name] <- NA
      next
    }
    
    filt_sig_counts[study, tool_name] <- length(which(filt_results[[study]]$adjP_table[, tool_name] < 0.05))
    
    # For rarified pipelines get total # ASVs from wilcoxonrare and for non-rarified get it from wilcoxonclr table.
    if(tool_name %in% c("lefse", "maaslin2rare", "ttestrare", "wilcoxonrare")) {
      filt_sig_percent[study, tool_name] <- (length(which(filt_results[[study]]$adjP_table[, tool_name] < 0.05)) / dim(filt_study_tab[["rare"]][[study]])[1]) * 100
    } else {
      filt_sig_percent[study, tool_name] <- (length(which(filt_results[[study]]$adjP_table[, tool_name] < 0.05)) / dim(filt_study_tab[["nonrare"]][[study]])[1]) * 100
    }
  }
}

chimera_percents_nonrare <- chimera_percents[, c("unfilt_nonrare", "filt_nonrare")]
rownames(chimera_percents_nonrare) <- study_name_mapfile[rownames(chimera_percents_nonrare), "clean"]
chimera_percents_nonrare$Dataset <- rownames(chimera_percents_nonrare)
chimera_percents_nonrare_melt <- melt(data = chimera_percents_nonrare, ids = "Dataset")
chimera_percents_nonrare_melt$variable <- as.character(chimera_percents_nonrare_melt$variable)
chimera_percents_nonrare_melt$variable[which(chimera_percents_nonrare_melt$variable == "unfilt_nonrare")] <- "Unfiltered"
chimera_percents_nonrare_melt$variable[which(chimera_percents_nonrare_melt$variable == "filt_nonrare")] <- "Filtered"
chimera_percents_nonrare_melt$variable <- factor(chimera_percents_nonrare_melt$variable, levels = c("Unfiltered", "Filtered"))
chimera_percents_nonrare_melt <- chimera_percents_nonrare_melt[order(chimera_percents_nonrare_melt$value, decreasing = TRUE), ]
chimera_percents_nonrare_Dataset_order <- chimera_percents_nonrare_melt$Dataset[-which(duplicated(chimera_percents_nonrare_melt$Dataset))]
chimera_percents_nonrare_melt$Dataset <- factor(chimera_percents_nonrare_melt$Dataset,
                                                levels=rev(chimera_percents_nonrare_Dataset_order))

chimera_percent_plot <- ggplot(data = chimera_percents_nonrare_melt, aes(x = variable, y = Dataset, fill = value)) +
                              geom_tile() +
                              theme_bw() +
                              xlab("") +
                              ylab("") +
                              labs(fill="% chimeras") +
                              scale_fill_gradient(low="cornflowerblue", high="dark blue", limits = c(0, 40)) +
                              geom_text(aes(label=round(value, 2)), colour = "white") +
                              theme(plot.title = element_text(hjust = 0.5),
                                    axis.text.x = element_text(angle = 45, vjust = 0.5))


chimera_spearman_df <- data.frame(matrix(NA, nrow = ncol(unfilt_sig_percent) - 1, ncol = 2))
rownames(chimera_spearman_df) <- colnames(unfilt_sig_percent)[-1]
colnames(chimera_spearman_df) <- c("Unfiltered", "Filtered")
rownames(chimera_spearman_df) <- sort(rownames(chimera_spearman_df))
chimera_percents <- chimera_percents[rownames(unfilt_sig_percent), ]

for (tool_name in rownames(chimera_spearman_df)) {
  
  Unfiltered_spearman <- cor.test(chimera_percents$unfilt_nonrare,
                                  unfilt_sig_percent[, tool_name],
                                  method = "spearman", exact = FALSE)
  
  if (Unfiltered_spearman$p.value < 0.05) {
    chimera_spearman_df[tool_name, "Unfiltered"] <- Unfiltered_spearman$estimate
  } else {
    chimera_spearman_df[tool_name, "Unfiltered"] <- NA
  }

  Filtered_spearman <- cor.test(chimera_percents$unfilt_nonrare,
                                  filt_sig_percent[, tool_name],
                                  method = "spearman", exact = FALSE)
  
  if (Filtered_spearman$p.value < 0.05) {
    chimera_spearman_df[tool_name, "Filtered"] <- Filtered_spearman$estimate
  } else {
    chimera_spearman_df[tool_name, "Filtered"] <- NA
  }
}

rownames(chimera_spearman_df) <- tool_name_mapfile[rownames(chimera_spearman_df), "clean"]
chimera_spearman_df$Tool <- rownames(chimera_spearman_df)
chimera_spearman_df_melt <- melt(data = chimera_spearman_df, ids = "Tool")
chimera_spearman_df_melt$variable <- as.character(chimera_spearman_df_melt$variable)
chimera_spearman_df_melt$variable <- factor(chimera_spearman_df_melt$variable, levels = c("Unfiltered", "Filtered"))
chimera_spearman_df_melt <- chimera_spearman_df_melt[order(chimera_spearman_df_melt$value, decreasing = TRUE), ]
chimera_spearman_df_melt_Tool_order <- chimera_spearman_df_melt$Tool[-which(duplicated(chimera_spearman_df_melt$Tool))]
chimera_spearman_df_melt$Tool <- factor(chimera_spearman_df_melt$Tool,
                                           levels=rev(chimera_spearman_df_melt_Tool_order))


# Save chimera spearman correlations to file in plotting data folder (i.e., convert to csv).
chimera_spearman_csv <- chimera_spearman_df
chimera_spearman_csv <- chimera_spearman_csv[, c("Tool", "Unfiltered", "Filtered")]
write.table(x = chimera_spearman_csv,
            file = "/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Plotting_data/Supp_figures/Supp_Fig2B_chimera_spearman.csv",
            sep = ",", row.names = FALSE, col.names = TRUE, quote = FALSE)

chimera_spearman_plot <- ggplot(data = chimera_spearman_df_melt, aes(x = variable, y = Tool, fill = value)) +
                                geom_tile() +
                                theme_bw() +
                                xlab("") +
                                ylab("") +
                                labs(fill="Spearman\ncorrelation") +
                                scale_fill_gradient(low="pink", high="dark red", limits = c(0, 1)) +
                                geom_text(aes(label=round(value, 2)), colour = "white") +
                                theme(plot.title = element_text(hjust = 0.5),
                                      axis.text.x = element_text(angle = 45, vjust = 0.5))

chimera_spearman_plot_w_blank <- plot_grid(chimera_spearman_plot, NULL, nrow = 2)

chimera_plot <- plot_grid(chimera_percent_plot, chimera_spearman_plot_w_blank,
                          labels = c('A', 'B'))

ggsave(filename=paste(display_items_out, "Supp_figures", "Supp_Fig2.pdf", sep="/"),
        plot = chimera_plot, width = 7.5, height=7.5, units="in", dpi=600)
 
 