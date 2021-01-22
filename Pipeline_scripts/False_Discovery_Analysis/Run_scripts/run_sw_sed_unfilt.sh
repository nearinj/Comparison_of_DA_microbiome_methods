#!/bin/bash

parallel -j 5 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A ~/projects/Hackathon/Studies/sw_sed_detender/sw_sed_detender_ASVs_table.tsv -G {1} -R ~/projects/Hackathon/Studies/sw_sed_detender/sw_sed_detender_ASVs_table_rare.tsv -O ~/projects/Hackathon/Studies/sw_sed_detender/False_Discovery_Testing/results_nonfilt/{#}' ::: ~/projects/Hackathon/Studies/sw_sed_detender/False_Discovery_Testing/nonfilt_tabs/*.tsv
