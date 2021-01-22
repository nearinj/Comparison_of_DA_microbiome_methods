#!/bin/bash

parallel --eta -j 20 -N4 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A {1} -G {2} -O {3} -D {4} -F 0.1' :::: <(cat ~/GitHub_Repos/Hackathon_testing/parallel_run_scripts/filt_input_files/sorted_combined_input.txt)

