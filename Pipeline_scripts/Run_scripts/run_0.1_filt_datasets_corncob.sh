#!/bin/bash

source ../../Config.sh
echo $DATA_DIR
export DATA_DIR

find "$DATA_DIR/Studies" -maxdepth 1 -mindepth 1 -type d | while read dir;
	do mkdir $dir/Fix_Results_0.1;
done

parallel --env $DATA_DIR -j 38 -N4 "./run_all_tools.sh -A $DATA_DIR{1} -G $DATA_DIR{2} -O $DATA_DIR{3} -D {4} -F 0.1 --ALDEX_SKIP T --ANCOM_SKIP T --DESEQ2_SKIP T --LEFSE_SKIP T --WILCOX_RARE_SKIP T --WILCOX_CLR_SKIP T --MAASLIN_RARE_SKIP T --MAASLIN_SKIP T --METAGENOME_SKIP T --EDGER_SKIP T --TTEST_RARE_SKIP T --LIMMA_TMM_SKIP T --LIMMA_TMMWSP_SKIP T" :::: <(cat input_parameters/sorted_combined_input.txt)

