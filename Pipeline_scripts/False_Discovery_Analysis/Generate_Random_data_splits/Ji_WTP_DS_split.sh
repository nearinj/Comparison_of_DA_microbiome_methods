#!/bin/bash

source ../../../Config.sh

mkdir $DATA_DIR/Studies/Ji_WTP_DS/False_Discovery_Testing



./Generate_Random_Splits.sh -A $DATA_DIR/Studies/Ji_WTP_DS/No_filt_Results/fixed_non_rare_tables/Ji_WTP_DS_ASVs_table.tsv -R $DATA_DIR/Studies/Ji_WTP_DS/Ji_WTP_DS_ASVs_table_rare.tsv -G $DATA_DIR/Studies/Ji_WTP_DS/Ji_WTP_DS_metadata.csv -O $DATA_DIR/Studies/Ji_WTP_DS/False_Discovery_Testing/

