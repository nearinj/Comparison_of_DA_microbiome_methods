### Comparison of microbiome differential abundance methods

The code and key intermediate files in this repository correspond to our manuscript:

  _Nearing et al. In Prep. Microbiome differential abundance methods produce disturbingly different results across 38 datasets._
  
Our goal with this work was to compare how similarly common DA methods perform on a range of 16S rRNA gene datasets.
Accordingly for the majority of this work we don't necessarily know the _right_ answer: we can mainly just say which tools are more similar to others.
However, we also included several analyses to help gauge the false positive rate and consistency of the tools on different datasets from the same environment.

#### Repository organization

* *Analyis_scripts* contains R notebooks describing the key analyses run to produce the results presented in our manuscript. These are split up by each type of analysis (which is mainly indicated by figure number).

* *Figures* contains PDFs of the manuscript figures.

* *Pipeline_scripts*: Contains all bash and R scripts for running each tool on each dataset. The idea with these scripts was to make it simple to run all tools automatically on each dataset and to easily add additional datasets without more overhead. The key script is "run_all_tools.sh" for running all tools on a given dataset.
  
  
#### Running the analysis
  * Within this repo there is a config file named *config.sh* that contains all the PATHs used by the pipeline scripts to generate all the results analysised in this project. All the raw tables along with the correct folder structuring is available in figshare at the following link: https://figshare.com/articles/dataset/16S_rRNA_Microbiome_Datasets/14531724
  
  * Users can unzip the raw data and point the config DATA_DIR parameter to where this file is unzipped i.e. (DATA_DIR="/home/USER/PATH_TO_UNZIP_DATA/Hackathon"). Note the users must also update the ANCOM_DIR parameter and the TOOL_DIR parameter to point to the Ancom2_Script folder within this repo and the Tool_scripts folder within this repo. ANCOM_DIR="/home/USER/THIS_REPO/Pipeline_scripts/Ancom2_Script" TOOL_DIR="/home/USER/THIS_REPO/Pipeline_scripts/Tool_scripts/
  
  * Finally the user needs to have all of the tools installed to be able to run the main script "run_all_tools.sh" on a dataset.
  * R version: 3.6.3
  * A list of required R packages:
    * "GUniFrac" Version: 1.1
    * "ALDEx2" Version: 1.18.0 
    * "exactRankTests" Version: 0.8.31
    * "nlme" Version: 3.1.149
    * "dplyr" Version: 0.8.5
    * "ggplot2" Version: 3.3.0
    * "compositions" Version: 1.40.2
    * "corncob" Version: 0.1.0 
    * "phyloseq" Version: 1.29.0
    * "DESeq2" Version: 1.26.0
    * "edgeR" Version: 3.28.1
    * "Maaslin2" Version: 0.99.12
    * "metagenomeSeq" Version: 1.28.2
  
  * List of other requirements:
    * Installation of the LEFse conda enviornment. This environment should be named "hackathon"
  If you would like to change the name of this required environment you may change line 58 in the "run_all_tools.sh" script.
  
  
  * Once this is set up users can simply run the following scripts to generate results:
    * run_0.1_filt_datasets.sh --> runs all tools on the 38 filtered datasets
    * run_no_filt_datasets.sh --> runs all tools on the 38 unfiltered datasets
    * run_all_FP_datasets_filt.sh --> runs the false postive analysis for filtered datasets
    * run_all_FP_datasets_unfilt.sh --> runs the false postive analysis for unfiltered datasets
    * run_obesity_*.sh --> runs the obesity datasets for the consistency across datasets analysis
    * run_diarrhea_*.sh --> runs the diarrhea datasets for the consistency across datasets analysis
    * run_FP_unfilt_EXT.sh --> runs an additional 90 replicates for the unfilt FP analysis on all tools except for ANCOM, ALDEx2, and corncob.
  
#### Docker Image  
  A docker image with the correct versions is currently being designed to assist with this. 
  
#### Analysis scripts
  Additional packages were used during the analysis of the resulting tables from the "run_all_tools.sh" script
  * "corrplot" Version: 0.85
  * "pheatmap" Version: 1.0.12
  * "gridExtra" Version: 2.3
  * "cowplot" Version: 1.0.0
  * "ggridges" Version: 0.5.2
  * "ggrepel" Version: 0.8.1
  * "doParallel" Version: 1.0.15
  * "doMC" Version: 1.3.5
  * "matrixStats" Version: 0.56.0
  * "reshape2" Version: 1.4.4
  * "plyr" Version: 1.8.6
  * "ggplotify" Version: 0.0.5
  * "RColorBrewer" Version: 1.1.2
  * "ggbeeswarm" Version: 0.6.0
  * "scales" Version: 1.1.0
  * "ape" Version: 5.3
  * "ComplexHeatmap" Version: 2.2.0
  * "knitr" Version: 1.23
  * "kableExtra" Version: 1.1.0
  * "Matching" Version: 4.9.7
  * "rowr" Version: 1.1.3
  * "tidyverse" Version: 1.3.0
  * "vegan" Version: 2.5.6
  * "parallelDist" Version: 0.2.4
#### Running run_all_tools.sh on a single dataset
  * To run this script on a single dataset with no filtering you can run the following command:
  ```
  run_all_tools.sh -A ASV_TABLE.tsv -G METADATA_FILE.tsv -O OUTPUT_FOLDER -R RARIFIED_ASV_TABLE.tsv
  ```
  Note that the metadatafile should be a two column tsv table with the first column having the sample names and the second column having the sample groupings.(maximum 2 groupings)
  * To run this script on a single dataset with filtering you can run the following command: 
  ```
  run_all_tools.sh -A ASV_TABLE.tsv -G METADATA_FILE.tsv -O OUTPUT_FOLDER -D 2000 -F 0.1
  ```
  * -D represents the rarefaction depth
  * -F represents the prevelance filtering. I.e. 0.1 represents a 10% prevelance filter (the used within the analysis of the linked manuscript)
