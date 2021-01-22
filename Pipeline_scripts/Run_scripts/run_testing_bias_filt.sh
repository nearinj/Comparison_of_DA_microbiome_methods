#!/bin/bash


parallel -j 9 -N4 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A {2} -G {3} -O {1} -D {4} -F 0.1' :::: <(cat ~/GitHub_Repos/Hackathon_testing/Testing_Bias_robustness/filt_input/sort_combined_input.txt)
