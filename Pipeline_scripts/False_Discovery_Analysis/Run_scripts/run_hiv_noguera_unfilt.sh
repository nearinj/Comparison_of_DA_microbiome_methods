#!/bin/bash

parallel -j 10 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A ~/projects/Hackathon/Studies/hiv_noguerajulian/hiv_noguerajulian_ASVs_table.tsv -G {1} -R ~/projects/Hackathon/Studies/hiv_noguerajulian/hiv_noguerajulian_ASVs_table_rare.tsv -O ~/projects/Hackathon/Studies/hiv_noguerajulian/False_Discovery_Testing/results_nonfilt/{#}' ::: ~/projects/Hackathon/Studies/hiv_noguerajulian/False_Discovery_Testing/nonfilt_tabs/*.tsv

