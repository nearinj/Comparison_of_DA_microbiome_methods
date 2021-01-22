#!/bin/bash


parallel -j 9 -N4 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A {3} -G {4} -O {1} -R {2}' :::: <(cat ~/GitHub_Repos/Hackathon_testing/Testing_Bias_robustness/nonfilt_input/sort_combined_input.txt)
