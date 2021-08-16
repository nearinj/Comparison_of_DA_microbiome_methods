#!/bin/bash

source ../../Config.sh

mkdir $DATA_DIR/Studies/hiv_noguerajulian/False_Discovery_Testing/results_filt

for i in {1..100}
do
mkdir $DATA_DIR/Studies/hiv_noguerajulian/False_Discovery_Testing/results_filt/$i
done


parallel -j 25 "./run_all_tools.sh -A $DATA_DIR/Studies/hiv_noguerajulian/hiv_noguerajulian_ASVs_table.tsv -G {1} -O $DATA_DIR/Studies/hiv_noguerajulian/False_Discovery_Testing/results_filt/{#} -D 2012 -F 0.1 --DESEQ2_SKIP T --LEFSE_SKIP T --WILCOX_RARE_SKIP T --WILCOX_CLR_SKIP T --METAGENOME_SKIP T --EDGER_SKIP T --TTEST_RARE_SKIP T --LIMMA_TMM_SKIP T --LIMMA_TMMWSP_SKIP T --ALDEX_SKIP T --CORNCOB_SKIP T --ANCOM_SKIP T" ::: $DATA_DIR/Studies/hiv_noguerajulian/False_Discovery_Testing/nonfilt_tabs/*.tsv*
