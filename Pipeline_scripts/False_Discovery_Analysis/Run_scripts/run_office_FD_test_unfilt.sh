#!/bin/bash

parallel -j 10 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A ~/projects/Hackathon/Studies/Office/Office_ASVs_table.tsv -G {1} -R ~/projects/Hackathon/Studies/Office/Office_ASVs_table_rare.tsv -O ~/projects/Hackathon/Studies/Office/False_Discovery_testing/results_nonfilt/{#}' ::: ~/projects/Hackathon/Studies/Office/False_Discovery_testing/nonfilt_tabs/*.tsv
