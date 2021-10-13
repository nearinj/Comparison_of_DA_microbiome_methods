#!/bin/bash

source ../../Config.sh
echo $DATA_DIR
export DATA_DIR

find "$DATA_DIR/Studies" -maxdepth 1 -mindepth 1 -type d | while read dir;
	do mkdir $dir/No_filt_Results;
done


parallel --env $DATA_DIR  -j 9 -N4 "./run_all_tools.sh -A $DATA_DIR{2} -G $DATA_DIR{3} -O $DATA_DIR{4} -R $DATA_DIR{1} --ALDEX_SKIP T --ANCOM_SKIP T --DESEQ2_SKIP T --LEFSE_SKIP T --WILCOX_RARE_SKIP T --WILCOX_CLR_SKIP T --MAASLIN_RARE_SKIP T --MAASLIN_SKIP T --METAGENOME_SKIP T --EDGER_SKIP T --TTEST_RARE_SKIP T --LIMMA_TMM_SKIP T --LIMMA_TMMWSP_SKIP T" :::: <(cat input_parameters/sorted_input.tsv)

