#!/bin/bash


parallel -j 10 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A ~/projects/Hackathon/Studies/Ji_WTP_DS/Ji_WTP_DS_ASVs_table.tsv -G {1} -O ~/projects/Hackathon/Studies/Ji_WTP_DS/False_Discovery_Testing/results_filt/{#} -D 35880 -F 0.1' ::: ~/projects/Hackathon/Studies/Ji_WTP_DS/False_Discovery_Testing/nonfilt_tabs/*.tsv
