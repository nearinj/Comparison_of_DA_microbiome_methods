#!/bin/bash


source ../../../Config.sh


echo $DATA_DIR

mkdir $DATA_DIR/Studies/Office/False_Discovery_Testing


./Generate_Random_Splits.sh -A $DATA_DIR/Studies/Office/No_filt_Results/fixed_non_rare_tables/Office_ASVs_table.tsv -R $DATA_DIR/Studies/Office/Office_ASVs_table_rare.tsv -G $DATA_DIR/Studies/Office/Office_metadata.tsv -O $DATA_DIR/Studies/Office/False_Discovery_Testing/
