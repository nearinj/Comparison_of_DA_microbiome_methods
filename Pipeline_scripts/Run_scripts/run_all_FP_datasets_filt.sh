#!/bin/bash

source ../../Config.sh

mkdir $DATA_DIR/logs/

## arcticfresh

FP_runs/run_arcticfresh_filt.sh 2> $DATA_DIR/logs/arctic_filt.log

## blueberry
FP_runs/run_blueberry_filt.sh 2> $DATA_DIR/logs/blueberry_filt.log

## goodrich
FP_runs/run_goodrich_filt.sh 2> $DATA_DIR/logs/goodrich_filt.log

## hiv_nog
FP_runs/run_hiv_noguera_filt.sh 2> $DATA_DIR/logs/hiv_nog_filt.log

## JI_WTP
FP_runs/run_JI_WTP_DS_filt.sh 2> $DATA_DIR/logs/Ji_WTP_filt.log

## Office
FP_runs/run_office_FD_test_filt.sh 2> $DATA_DIR/logs/office_filt.log

## schubert
FP_runs/run_schubert_filt.sh 2> $DATA_DIR/logs/schubert_filt.log

## sw_sed
FP_runs/run_sw_sed_filt.sh 2> $DATA_DIR/logs/sw_sed_filt.log

