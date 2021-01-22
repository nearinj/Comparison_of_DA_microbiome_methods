#!/bin/bash

parallel -j 5 --link '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A ~/projects/Hackathon/Studies/ob_goodrich/ob_goodrich_ASVs_table.tsv -G {1} -R ~/projects/Hackathon/Studies/ob_goodrich/ob_goodrich_ASVs_table_rare.tsv -O ~/projects/Hackathon/Studies/ob_goodrich/False_Discovery_Testing/results_nonfilt/{#}' ::: ~/projects/Hackathon/Studies/ob_goodrich/False_Discovery_Testing/nonfilt_tabs/*.tsv
