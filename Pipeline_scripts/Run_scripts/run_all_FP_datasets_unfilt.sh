#!/bin/bash

source ../../Config.sh

mkdir $DATA_DIR/logs

## arcticfresh

FP_runs/run_arcticfresh_unfilt.sh 2> $DATA_DIR/logs/artic_unfilt.log

## blueberry
FP_runs/run_blueberry_unfilt.sh 2> $DATA_DIR/logs/blueberry_unfilt.log

## goodrich
FP_runs/run_goodrich_unfilt.sh 2> $DATA_DIR/logs/goodrich_unfilt.log

## hiv_nog
FP_runs/run_hiv_noguera_unfilt.sh 2> $DATA_DIR/logs/hiv_nog_unfilt.log

## JI_WTP
FP_runs/run_JI_WTP_DS_unfilt.sh 2> $DATA_DIR/logs/Ji_WTP_unfilt.log

## Office
FP_runs/run_office_FD_test_unfilt.sh 2> $DATA_DIR/logs/office_unfilt.log

## schubert
FP_runs/run_schubert_unfilt.sh 2> $DATA_DIR/logs/schubert_unfilt.log

## sw_sed
FP_runs/run_sw_sed_unfilt.sh 2> $DATA_DIR/logs/sw_sed_unfilt.log

