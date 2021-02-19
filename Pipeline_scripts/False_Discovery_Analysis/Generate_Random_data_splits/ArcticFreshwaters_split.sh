#!/bin/bash


source ../../../Config.sh
echo $DATA_DIR

mkdir $DATA_DIR/Studies/ArcticFreshwaters/False_Discovery_Testing

./Generate_Random_Splits.sh -A $DATA_DIR/Studies/ArcticFreshwaters/No_filt_Results/fixed_non_rare_tables/ArcticFreshwaters_ASVs_table.tsv -R $DATA_DIR/Studies/ArcticFreshwaters/ArcticFreshwaters_ASVs_table_rare.tsv -G $DATA_DIR/Studies/ArcticFreshwaters/ArcticFreshwaters_meta.tsv -O $DATA_DIR/Studies/ArcticFreshwaters/False_Discovery_Testing/


