#!/bin/bash

source ../../Config.sh
echo $DATA_DIR
export DATA_DIR

find "$DATA_DIR/Studies" -maxdepth 1 -mindepth 1 -type d | while read dir;
	do mkdir $dir/No_filt_Results;
done


parallel --env $DATA_DIR  -j 9 -N4 "./run_all_tools.sh -A $DATA_DIR{2} -G $DATA_DIR{3} -O $DATA_DIR{4} -R $DATA_DIR{1}" :::: <(cat input_parameters/sorted_input.tsv)

