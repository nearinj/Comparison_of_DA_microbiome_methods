#!/bin/bash

parallel -j 5 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A ~/projects/Hackathon/Studies/ArcticFreshwaters/ArcticFreshwaters_ASVs_table.tsv -G {1} -R ~/projects/Hackathon/Studies/ArcticFreshwaters/ArcticFreshwaters_ASVs_table_rare.tsv -O ~/projects/Hackathon/Studies/ArcticFreshwaters/False_Discovery_Testing/results_nonfilt/{#}' ::: ~/projects/Hackathon/Studies/ArcticFreshwaters/False_Discovery_Testing/nonfilt_tabs/*.tsv
