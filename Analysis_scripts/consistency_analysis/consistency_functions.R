### Functions used for the consistency analyses.

read_table_and_check_line_count <- function(filepath, ...) {
  # Function to read in table and to check whether the row count equals the expected line count of the file.
  
  exp_count <- as.numeric(sub(pattern = " .*$", "", system(command = paste("wc -l", filepath, sep=" "), intern = TRUE)))
  
  df <- read.table(filepath, ...)
  
  if(length(grep("^V", colnames(df))) != ncol(df)) {
    exp_count <- exp_count - 1
  }
  
  if(exp_count != nrow(df)) {
    stop(paste("Expected ", as.character(exp_count), " lines, but found ", as.character(nrow(df))))
  } else {
    return(df) 
  }
}


read_genera_hackathon_results <- function(study,
                                          results_folder="Genus_filt") {
  
  da_tool_filepath <- list()
  da_tool_filepath[["aldex2"]] <- paste(study, results_folder, "Aldex_out/Aldex_res.tsv", sep = "/")
  da_tool_filepath[["ancom"]] <- paste(study, results_folder, "ANCOM_out/Ancom_res.tsv", sep = "/")
  da_tool_filepath[["corncob"]] <- paste(study, results_folder, "Corncob_out/Corncob_results.tsv", sep = "/")
  da_tool_filepath[["deseq2"]] <- paste(study, results_folder, "Deseq2_out/Deseq2_results.tsv", sep = "/")
  da_tool_filepath[["edger"]] <- paste(study, results_folder, "edgeR_out/edgeR_res.tsv", sep = "/")
  da_tool_filepath[["lefse"]] <- paste(study, results_folder, "Lefse_out/Lefse_results.tsv", sep = "/")
  da_tool_filepath[["limma_voom_TMM"]] <- paste(study, results_folder, "limma_voom_tmm_out/limma_voom_tmm_res.tsv", sep = "/")
  da_tool_filepath[["limma_voom_TMMwsp"]] <- paste(study, results_folder, "Limma_voom_TMMwsp/limma_voom_tmmwsp_res.tsv", sep = "/")
  da_tool_filepath[["maaslin2"]] <- paste(study, results_folder, "Maaslin2_out/all_results.tsv", sep = "/")
  da_tool_filepath[["maaslin2rare"]] <- paste(study, results_folder, "Maaslin2_rare_out/all_results.tsv", sep = "/")
  da_tool_filepath[["metagenomeSeq"]] <- paste(study, results_folder, "metagenomeSeq_out/mgSeq_res.tsv", sep = "/")
  da_tool_filepath[["ttestrare"]] <- paste(study, results_folder, "t_test_rare_out/t_test_res.tsv", sep = "/")
  da_tool_filepath[["wilcoxonclr"]] <- paste(study, results_folder, "Wilcoxon_CLR_out/Wil_CLR_results.tsv", sep = "/")
  da_tool_filepath[["wilcoxonrare"]] <- paste(study, results_folder, "Wilcoxon_rare_out/Wil_rare_results.tsv", sep = "/")
  
  adjP_colname <- list()
  adjP_colname[["aldex2"]] <- "wi.eBH"
  adjP_colname[["ancom"]] <- "detected_0.9"
  adjP_colname[["corncob"]] <- "x"
  adjP_colname[["deseq2"]] <- "padj"
  adjP_colname[["edger"]] <- "FDR"
  adjP_colname[["lefse"]] <- "V5"
  adjP_colname[["limma_voom_TMM"]] <- "adj.P.Val"
  adjP_colname[["limma_voom_TMMwsp"]] <- "adj.P.Val"
  adjP_colname[["maaslin2"]] <- "qval"
  adjP_colname[["maaslin2rare"]] <- "qval"
  adjP_colname[["metagenomeSeq"]] <- "adjPvalues"
  adjP_colname[["ttestrare"]] <- "x"
  adjP_colname[["wilcoxonclr"]] <- "x"
  adjP_colname[["wilcoxonrare"]] <- "x"
  
  
  # Read in results files and run sanity check that results files have expected number of lines
  da_tool_results <- list()
  
  missing_tools <- c()
  
  for(da_tool in names(da_tool_filepath)) {
    
    if(! (file.exists(da_tool_filepath[[da_tool]]))) {
      missing_tools <- c(missing_tools, da_tool)
      message(paste("File ", da_tool_filepath[[da_tool]], " not found. Skipping.", sep=""))
      next
    }
    
    if(da_tool %in% c("ancom", "maaslin2", "maaslin2rare")) {
      da_tool_results[[da_tool]] <- read_table_and_check_line_count(da_tool_filepath[[da_tool]], sep="\t", row.names=2, header=TRUE)
    } else if(da_tool == "lefse") {
      da_tool_results[[da_tool]] <- read_table_and_check_line_count(da_tool_filepath[[da_tool]], sep="\t", row.names=1, header=FALSE, stringsAsFactors=FALSE)
      rownames(da_tool_results[[da_tool]]) <- gsub("^f_", "", rownames(da_tool_results[[da_tool]]))
    } else {
      da_tool_results[[da_tool]] <- read_table_and_check_line_count(da_tool_filepath[[da_tool]], sep="\t", row.names=1, header=TRUE)
    }
  }
  
  # Slight modification needed with genus results specifically: convert all "." to "_" so that the strings are identical.
  # Similarly need to convert all "." to "/"
  for(da_tool in names(da_tool_filepath)) {
    rownames(da_tool_results[[da_tool]]) <- gsub("\\.", "_", rownames(da_tool_results[[da_tool]]))
    rownames(da_tool_results[[da_tool]]) <- gsub("/", "_", rownames(da_tool_results[[da_tool]]))
    
  }
  
  
  # Combine corrected P-values into same table.
  all_rows <- c()
  
  for(da_tool in names(adjP_colname)) {
    all_rows <- c(all_rows, rownames(da_tool_results[[da_tool]]))
  }
  all_rows <- all_rows[-which(duplicated(all_rows))]
  
  adjP_table <- data.frame(matrix(NA, ncol=length(names(da_tool_results)), nrow=length(all_rows)))
  colnames(adjP_table) <- names(da_tool_results)
  rownames(adjP_table) <- all_rows
  
  for(da_tool in colnames(adjP_table)) {
    
    if(da_tool %in% missing_tools) {
      next
    }
    
    if(da_tool == "lefse") {
      
      tmp_lefse <- da_tool_results[[da_tool]][, adjP_colname[[da_tool]]]
      tmp_lefse[which(tmp_lefse == "-")] <- NA
      adjP_table[rownames(da_tool_results[[da_tool]]), da_tool] <- as.numeric(tmp_lefse)
      
      lefse_tested_asvs <- rownames(da_tool_results$wilcoxonrare)[which(! is.na(da_tool_results$wilcoxonrare))]
      lefse_NA_asvs <- rownames(da_tool_results$lefse)[which(is.na(tmp_lefse))]
      
      adjP_table[lefse_NA_asvs[which(lefse_NA_asvs %in% lefse_tested_asvs)], da_tool] <- 1
      
    } else if(da_tool == "ancom") {
      
      sig_ancom_hits <- which(da_tool_results[[da_tool]][, adjP_colname[[da_tool]]])
      ancom_results <- rep(1, length(da_tool_results[[da_tool]][, adjP_colname[[da_tool]]]))
      ancom_results[sig_ancom_hits] <- 0
      adjP_table[rownames(da_tool_results[[da_tool]]), da_tool] <- ancom_results
      
    } else if(da_tool %in% c("wilcoxonclr", "wilcoxonrare", "ttestrare")) {
      
      # Need to perform FDR-correction on these outputs.
      adjP_table[rownames(da_tool_results[[da_tool]]), da_tool] <- p.adjust(da_tool_results[[da_tool]][, adjP_colname[[da_tool]]], "fdr")
      
    } else {
      adjP_table[rownames(da_tool_results[[da_tool]]), da_tool] <- da_tool_results[[da_tool]][, adjP_colname[[da_tool]]]
    }
  }
  
  return(list(raw_tables=da_tool_results,
              adjP_table=adjP_table))
  
}