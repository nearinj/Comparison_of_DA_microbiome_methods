#!/bin/bash

parallel -j 10 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A ~/projects/Hackathon/Studies/Office/Office_ASVs_table.tsv -G {1} -O ~/projects/Hackathon/Studies/Office/False_Discovery_testing/results_filt/{#} -D 2000 -F 0.1' ::: ~/projects/Hackathon/Studies/Office/False_Discovery_testing/nonfilt_tabs/*.tsv
