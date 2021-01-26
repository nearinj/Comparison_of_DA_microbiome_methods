### Comparison of microbiome differential abundance methods

The code and key intermediate files in this repository correspond to our manuscript:

  _Nearing et al. In Prep. Microbiome differential abundance methods produce disturbingly different results across 38 datasets._
  
Our goal with this work was to compare how similarly common DA methods perform on a range of 16S rRNA gene datasets.
Accordingly for the majority of this work we don't necessarily know the _right_ answer: we can mainly just say which tools are more similar to others.
However, we also included several analyses to help gauge the false positive rate and consistency of the tools on different datasets from the same environment.

#### Repository organization

* *Analyis_scripts* contains R notebooks describing the key analyses run to produce the results presented in our manuscript. These are split up by each type of analysis (which is mainly indicated by figure number).

* *Figures* contains PDFs of the manuscript figures.

* *Pipeline_scripts*: Contains all bash and R scripts for running each tool on each dataset. The idea with these scripts was to make it simple to run all tools automatically on each dataset and to easily add additional datasets without more overhead. The key script is "Run_all_tools_fix2.sh" for running all tools on a given dataset.

