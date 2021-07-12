#!/bin/bash

source ../../Config.sh

#mkdir $DATA_DIR/Studies/Office/False_Discovery_Testing/results_nonfilt_ext

#for i in {1..90}
#do
#mkdir $DATA_DIR/Studies/Office/False_Discovery_Testing/results_nonfilt_ext/$i
#done

parallel -j 30 "./run_all_tools.sh -A $DATA_DIR/Studies/Office/Office_ASVs_table.tsv -G {1} -R $DATA_DIR/Studies/Office/Office_ASVs_table_rare.tsv -O $DATA_DIR/Studies/Office/False_Discovery_Testing/results_nonfilt_ext/{#} --DESEQ2_SKIP T --LEFSE_SKIP T --WILCOX_RARE_SKIP T --WILCOX_CLR_SKIP T --MAASLIN_RARE_SKIP T --MAASLIN_SKIP T --METAGENOME_SKIP T --EDGER_SKIP T --TTEST_RARE_SKIP T --LIMMA_TMM_SKIP T --LIMMA_TMMWSP_SKIP T --ALDEX_SKIP T" ::: $DATA_DIR/Studies/Office/False_Discovery_Testing/nonfilt_tabs/*.tsvext
