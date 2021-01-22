#!/bin/bash

ASV_table_Path=
Output_Path=
Rar_ASV_table_Path=
Filt_ASV_table=
Filt_Rar_ASV_table=
Groupings_Path=

## loop that accepts arguments from command line
while [ "$1" != "" ]; do
	case $1 in
		-A | --ASV_table )
			shift
			ASV_table_Path=$1
			;;
		-R | --rar_ASV_table )
			shift
			Rar_ASV_table_Path=$1
			;;
		-G | --Groupings )
			shift
			Groupings_Path=$1
			;;
		-FA | --Filt_ASV_table )
			shift
			Filt_ASV_table=$1
			;;
		-FR | --Filt_Rar_ASV_table )
			shift
			Filt_Rar_ASV_table=$1
			;;
		-O | --output )
			shift
			Output_Path=$1
			;;
		* )
			echo "argument not recognized"
			exit 1
	esac
	shift
done

### deal with nonfilt samples first
mkdir $Output_Path/nonfilt_tabs
nonfilt_out=$Output_Path/nonfilt_tabs
## Rscript that takes in ASV table, Groupings table, Rar table and generates 100 new random grouping files
## along with a single ASV and rar ASV table that comes from samples of the largest grouping
Rscript Generate_splits.R $ASV_table_Path $Groupings_Path $Rar_ASV_table_Path $nonfilt_out

## Okay now to deal with the filtered data
mkdir $Output_Path/filt_tabs
filt_out=$Output_Path/filt_tabs

Rscript Generate_splits.R $Filt_ASV_table $Groupings_Path $Filt_Rar_ASV_table $filt_out

## done! random groupings files should be generated


