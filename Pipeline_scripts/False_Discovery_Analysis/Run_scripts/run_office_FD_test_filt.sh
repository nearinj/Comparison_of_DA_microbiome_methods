#!/bin/bash

source ../../../Config.sh

mkdir $DATA_DIR/Studies/Office/False_Discovery_Testing/results_filt

for i in {1..10}
do
mkdir $DATA_DIR/Studies/Office/False_Discovery_Testing/results_filt/$i
done

parallel -j 10 "../../run_all_tools.sh -A $DATA_DIR/Studies/Office/Office_ASVs_table.tsv -G {1} -O $DATA_DIR/Studies/Office/False_Discovery_Testing/results_filt/{#} -D 2000 -F 0.1" ::: $DATA_DIR/Studies/Office/False_Discovery_Testing/nonfilt_tabs/*.tsv
