#!/bin/bash

firehose_root=/titan/cancerregulome9/TCGA/firehose
run_type_found=false
date_found=false
output_dir_found=false

while [[ $# > 0 ]]; do
	option="$1"
	
	case $option in
		-r|--run-type)
		firehose_run_type="$2"
		run_type_found=true
		shift
		;;
		-d|--date)
		firehose_data_date="$2"
		date_found=true
		shift
		;;
		-o|--maf-output-dir)
		firehose_output_maf_dir="$2"
		if [[ ! -d $firehose_output_maf_dir ]]; then
			echo "Creating output directory $firehose_output_maf_dir..."
			mkdir -p $firehose_output_maf_dir 
		fi
		output_dir_found=true
		shift
		;;
		*)
		
		;;
	esac
	shift
done

if [[ "$run_type_found" = false ]]; then
	echo "Usage: -r [ stddata | analyses ] required."
	exit
fi

if [[ "$date_found" = false ]]; then
	# use the latest date
	firehose_data_date=`ls -d $firehose_root/$firehose_run_type* | sort -r | head -1 | cut -d "_" -f3-`
	echo "Using $firehose_run_type data from $firehose_data_date..."
fi

if [[ "$output_dir_found" = false ]]; then
	# create a subdirectory in the current working directory
	mkdir -p preprocessed_firehose_mafs/$firehose_data_date/$firehose_run_type/maf
	mkdir -p preprocessed_firehose_mafs/$firehose_data_date/$firehose_run_type/maf_manifest
	firehose_output_maf_dir=$PWD/preprocessed_firehose_mafs/$firehose_data_date/maf
	firehose_maf_manifest=preprocessed_firehose_mafs/$firehose_data_date/$firehose_run_type/maf_manifest/firehose_$firehose_run_type_$firehose_data_date_maf_manifest.tsv
else
	# create a subdirectory for mafs and maf manifests
	mkdir -p $firehose_output_maf_dir/maf
	mkdir -p $firehose_output_maf_dir/maf_manifest
	firehose_maf_manifest=$firehose_output_maf_dir/maf_manifest/firehose_$firehose_run_type_$firehose_data_date_maf_manifest.tsv
fi

#firehose_data_type="stddata" #or "analyses"
#firehose_data_date="2015_04_02"
#firehose_output_maf_dir=/titan/cancerregulome9/workspaces/users/ahahn/firehose_mafs
#firehose_maf_manifest=/titan/cancerregulome9/workspaces/users/ahahn/maf_manifests/firehose_maf_20150402.tsv

# Create a new maf manifest file
echo -e "tumor-short-code\tdate\tpoint-person\ttag\tinternal-path" > $firehose_maf_manifest

# get the tumor types
tumor_types=`ls -d $firehose_root/$firehose_run_type__$firehose_data_date/*/ | cut -d "/" -f 7`

# alternate date format
alternate_date=`echo $firehose_date | sed 's/_//g'`

for tumor_type in $tumor_types; do
	if [[ $firehose_data_type == "stddata" ]]; then
		firehose_input_maf_pattern="gdac.broadinstitute.org_$tumor_type.Mutation_Packager_Calls.Level_3.2015040200.0.0.maf.txt"
	else firehose_input_maf_pattern="" fi
	
	# create maf file for the tumor type
	echo $tumor_type
	temp=`mktemp`
	
	if [[ -d $firehose_root/$firehose_data_type__$firehose_data_date/$tumor_type/$alternate_date/$firehose_input_maf_pattern ]]; then
		files_to_cat=`ls -1 $firehose_root/$firehose_data_type__$firehose_data_date/$tumor_type/$alternate_date/$firehose_input_maf_pattern`
		file_count=0
		for file in $files_to_cat; do
			if [[ $file_count > 0 ]]; then
				cat $file | awk '{ if ( NR > 1 ) { print } }' >> $temp
			else cat $file > $temp; fi
		
			file_count=$((file_count+1))
		done
		
		# Remove the last 18 columns from the resulting maf
		while read -r line; do
			echo "$line" | cut -d $'\t' -f1-34 >> $firehose_maf_dir/$tumor_type.maf
		done < "$temp"
		
		rm $temp
		
		# create a line in the maf manifest file pointing to the maf that was just created
		tumor_short_code=`echo $tumor_type | tr '[:upper:]' '[:lower:]'`
		echo -e "$tumor_short_code\t04/02/2015\tUNKNOWN\tfirehose\t$firehose_maf_dir/$tumor_type.maf" >> $firehose_maf_manifest
	fi
done



