#!/bin/bash

source ../../Config.sh

mkdir $DATA_DIR/Studies/ob_goodrich/False_Discovery_Testing/results_filt

for i in {1..100}
do
mkdir $DATA_DIR/Studies/ob_goodrich/False_Discovery_Testing/results_filt/$i
done


parallel -j 25 "./run_all_tools.sh -A $DATA_DIR/Studies/ob_goodrich/ob_goodrich_ASVs_table.tsv -G {1} -O $DATA_DIR/Studies/ob_goodrich/False_Discovery_Testing/results_filt/{#} -D 3433 -F 0.1" ::: $DATA_DIR/Studies/ob_goodrich/False_Discovery_Testing/nonfilt_tabs/*.tsv*
