#!/bin/bash

source ../../../Config.sh

mkdir $DATA_DIR/Studies/sw_sed_detender/False_Discovery_Testing


./Generate_Random_Splits.sh -A $DATA_DIR/Studies/sw_sed_detender/No_filt_Results/fixed_non_rare_tables/sw_sed_detender_ASVs_table.tsv -R $DATA_DIR/Studies/sw_sed_detender/sw_sed_detender_ASVs_table_rare.tsv -G $DATA_DIR/Studies/sw_sed_detender/sw_sed_detender_metadata.tsv -O $DATA_DIR/Studies/sw_sed_detender/False_Discovery_Testing/

