#!/bin/bash

parallel --eta  -j 2 -N4 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix1.sh -A {2} -G {3} -O {4} -R {1}' :::: <(cat ~/GitHub_Repos/Hackathon_testing/parallel_run_scripts/No_filt_input_files/sorted_input.tsv)

