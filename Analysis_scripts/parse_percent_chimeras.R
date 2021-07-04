# Separate code to parse percent chimeras from each dataset.

rm(list = ls(all.names = TRUE))

library(seqinr)

setwd("/home/gavin/github_repos/hackathon/Comparison_of_DA_microbiome_methods/Misc_datafiles/uchime_ref_chimera_parsing/")

# Read in ASV tables (unfiltered and filtered as well as rarefied or not for each).
unfilt_study_tab  <- readRDS("/home/jacob/GitHub_Repos/Hackathon_testing/Data/unfilt_study_tab_21_04_07.RDS")
filt_study_tab <- readRDS("/home/jacob/GitHub_Repos/Hackathon_testing/Data/filt_study_tab_21_04_07.RDS")

# Read in mapping of datasets to UCHIME ref (implemented in VSEARCH) non-chimera output FASTAs.
uchime_ref_info <- read.table("uchime_ref_chimera_filenames.txt", header = TRUE, sep = "\t", row.names = 1, stringsAsFactors = FALSE)

chimeras <- list()

for (study in rownames(uchime_ref_info)) {
 
  chimera_fastafile <- paste("/home/gavin/projects/hackathon/chimera_testing/uchime_ref_out", uchime_ref_info[study, "file"], sep = "/") 
  
  chimeras[[study]] <- names(seqinr::read.fasta(file = chimera_fastafile, seqtype = "DNA"))
  
}

percent_chimeras <- data.frame(matrix(NA, nrow = 38, ncol = 4))
rownames(percent_chimeras) <- names(unfilt_study_tab$rare)
colnames(percent_chimeras) <- c("filt_rare", "filt_nonrare", "unfilt_rare", "unfilt_nonrare")


for (study in rownames(uchime_ref_info)) {

  for (rare_set in c("rare", "nonrare")) {
   
     filt_ASVs <- rownames(filt_study_tab[[rare_set]][[study]])
     unfilt_ASVs <- rownames(unfilt_study_tab[[rare_set]][[study]])
    
     colout <- paste(c("filt", "unfilt"), "_", rare_set, sep = "")
     
     percent_chimeras[study, colout] <- c((length(which(filt_ASVs %in% chimeras[[study]])) / length(filt_ASVs)) * 100,
                                          (length(which(unfilt_ASVs %in% chimeras[[study]])) / length(unfilt_ASVs)) * 100)
  
  }
}

write.table(x = percent_chimeras,
            file = "uchime_ref_chimera_percents.tsv",
            row.names = TRUE, col.names = NA, quote = FALSE, sep = "\t")
