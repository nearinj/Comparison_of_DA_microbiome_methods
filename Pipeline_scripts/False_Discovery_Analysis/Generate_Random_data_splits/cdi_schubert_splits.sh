#!/bin/bash

source ../../../Config.sh

mkdir $DATA_DIR/Studies/cdi_schubert/False_Discovery_Testing


./Generate_Random_Splits.sh -A $DATA_DIR/Studies/cdi_schubert/No_filt_Results/fixed_non_rare_tables/cdi_schubert_ASVs_table.tsv -R $DATA_DIR/Studies/cdi_schubert/cdi_schubert_ASVs_table_rare.tsv -G $DATA_DIR/Studies/cdi_schubert/cdi_schubert_metadata.tsv -O $DATA_DIR/Studies/cdi_schubert/False_Discovery_Testing/
