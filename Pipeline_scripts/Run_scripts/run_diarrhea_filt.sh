#!/bin/bash

parallel -j 5 -N4 '~/GitHub_Repos/Hackathon_testing/Run_all_tools_fix2.sh -A {1} -G {2} -O {3} -D {4} -F 0.1' :::: <(cat ~/GitHub_Repos/Hackathon_testing/Testing_Bias_robustness/Diarrhea/filt_input/sort_combined.txt)
