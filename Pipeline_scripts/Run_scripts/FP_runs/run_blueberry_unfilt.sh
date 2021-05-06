#!/bin/bash

source ../../Config.sh

mkdir $DATA_DIR/Studies/Blueberry/False_Discovery_Testing/results_nonfilt

for i in {1..10}
do
mkdir $DATA_DIR/Studies/Blueberry/False_Discovery_Testing/results_nonfilt/$i
done


parallel -j 10 "./run_all_tools.sh -A $DATA_DIR/Studies/Blueberry/Blueberry_ASVs_table.tsv -G {1} -R $DATA_DIR/Studies/Blueberry/Blueberry_ASVs_table_rare.tsv -O $DATA_DIR/Studies/Blueberry/False_Discovery_Testing/results_nonfilt/{#}" ::: $DATA_DIR/Studies/Blueberry/False_Discovery_Testing/nonfilt_tabs/*.tsv
