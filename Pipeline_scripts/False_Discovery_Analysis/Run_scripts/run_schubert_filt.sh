#!/bin/bash


parallel -j 10 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A ~/projects/Hackathon/Studies/cdi_schubert/cdi_schubert_ASVs_table.tsv -G {1} -O ~/projects/Hackathon/Studies/cdi_schubert/False_Discovery_Testing/results_filt/{#} -D 2010 -F 0.1' ::: ~/projects/Hackathon/Studies/cdi_schubert/False_Discovery_Testing/nonfilt_tabs/*.tsv
