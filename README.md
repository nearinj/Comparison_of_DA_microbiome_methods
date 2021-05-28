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
  
  * Finally the user needs to have all of the tools installed for running this tool.
    A list of required R packages:
    * "exactRankTests"
    * "nlme"
    * "dplyr"
    * "ggplot2"
    * "compositions"
    * "ALDEx2"
    * "corncob"
    * "phyloseq"
    * "DESeq2"
    * "edgeR"
    * "Maaslin2"
    * "metagenomeSeq"
  
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
