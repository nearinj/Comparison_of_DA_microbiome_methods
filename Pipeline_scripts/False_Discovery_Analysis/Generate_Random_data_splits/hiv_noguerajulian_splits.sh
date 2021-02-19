#!/bin/bash

source ../../../Config.sh

mkdir $DATA_DIR/Studies/hiv_noguerajulian/False_Discovery_Testing



./Generate_Random_Splits.sh -A $DATA_DIR/Studies/hiv_noguerajulian/hiv_noguerajulian_ASVs_table.tsv -R $DATA_DIR/Studies/hiv_noguerajulian/hiv_noguerajulian_ASVs_table_rare.tsv -G $DATA_DIR/Studies/hiv_noguerajulian/hiv_noguerajulian_metadata.tsv -O $DATA_DIR/Studies/hiv_noguerajulian/False_Discovery_Testing/
