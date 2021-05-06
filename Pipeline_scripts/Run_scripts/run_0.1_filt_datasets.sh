#!/bin/bash

source ../../Config.sh
echo $DATA_DIR
export DATA_DIR

find "$DATA_DIR/Studies" -maxdepth 1 -mindepth 1 -type d | while read dir;
	do mkdir $dir/Fix_Results_0.1;
done

parallel --env $DATA_DIR -j 38 -N4 "./run_all_tools.sh -A $DATA_DIR{1} -G $DATA_DIR{2} -O $DATA_DIR{3} -D {4} -F 0.1" :::: <(cat input_parameters/sorted_combined_input.txt)

