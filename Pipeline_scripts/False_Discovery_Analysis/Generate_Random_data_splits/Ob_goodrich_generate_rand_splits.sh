#!/bin/bash

source ../../../Config.sh

mkdir $DATA_DIR/Studies/ob_goodrich/False_Discovery_Testing


./Generate_Random_Splits.sh -A $DATA_DIR/Studies/ob_goodrich/No_filt_Results/fixed_non_rare_tables/ob_goodrich_ASVs_table.tsv -R $DATA_DIR/Studies/ob_goodrich/ob_goodrich_ASVs_table_rare.tsv -G $DATA_DIR/Studies/ob_goodrich/ob_goodrich_metadata.tsv -O $DATA_DIR/Studies/ob_goodrich/False_Discovery_Testing/
