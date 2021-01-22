#!/bin/bash

parallel -j 5 -N4 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A {2} -G {3} -O {4} -R {1}' :::: <(cat ~/GitHub_Repos/Hackathon_testing/Testing_Bias_robustness/Diarrhea/nonfilt_input/sort_combined_input.txt)
