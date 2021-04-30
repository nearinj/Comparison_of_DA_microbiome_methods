#!/bin/bash

source ../../Config.sh

mkdir $DATA_DIR/logs

## arcticfresh

FP_runs/run_arcticfresh_unfilt_EXT.sh 2> $DATA_DIR/logs/artic_unfilt_EXT.log

## blueberry
FP_runs/run_blueberry_unfilt_EXT.sh 2> $DATA_DIR/logs/blueberry_unfilt_EXT.log

## goodrich
FP_runs/run_goodrich_unfilt_EXT.sh 2> $DATA_DIR/logs/goodrich_unfilt_EXT.log

## hiv_nog
FP_runs/run_hiv_noguera_unfilt_EXT.sh 2> $DATA_DIR/logs/hiv_nog_unfilt_EXT.log

## JI_WTP
FP_runs/run_JI_WTP_DS_unfilt_EXT.sh 2> $DATA_DIR/logs/Ji_WTP_unfilt_EXT.log

## Office
FP_runs/run_office_FD_test_unfilt_EXT.sh 2> $DATA_DIR/logs/office_unfilt_EXT.log

## schubert
FP_runs/run_schubert_unfilt_EXT.sh 2> $DATA_DIR/logs/schubert_unfilt_EXT.log

## sw_sed
FP_runs/run_sw_sed_unfilt_EXT.sh 2> $DATA_DIR/logs/sw_sed_unfilt_EXT.log

