#!/bin/bash

firehose_maf_dir=/titan/cancerregulome9/workspaces/users/ahahn/firehose_mafs
firehose_maf_manifest=/titan/cancerregulome9/workspaces/users/ahahn/maf_manifests/firehose_maf_20150402.tsv

# Create a new maf manifest file
echo -e "tumor-short-code\tdate\tpoint-person\ttag\tinternal-path" > $firehose_maf_manifest

# get the tumor types
tumor_types=`ls -d /titan/cancerregulome9/TCGA/firehose/stddata__2015_04_02/*/ | cut -d "/" -f 7`

for tumor_type in $tumor_types; do
	# create maf file for the tumor type
	echo $tumor_type
	if [[ -d /titan/cancerregulome9/TCGA/firehose/stddata__2015_04_02/$tumor_type/20150402/gdac.broadinstitute.org_$tumor_type.Mutation_Packager_Calls.Level_3.2015040200.0.0 ]]; then
		files_to_cat=`ls -1 /titan/cancerregulome9/TCGA/firehose/stddata__2015_04_02/$tumor_type/20150402/gdac.broadinstitute.org_$tumor_type.Mutation_Packager_Calls.Level_3.2015040200.0.0/TCGA*`
		file_count=0
		for file in $files_to_cat; do
			if [[ $file_count > 0 ]]; then
				cat $file | awk '{ if ( NR > 1 ) { print } }' >> $firehose_maf_dir/$tumor_type.maf
			else cat $file > $firehose_maf_dir/$tumor_type.maf; fi
		
			file_count=$((file_count+1))
		done
		# create a line in the maf manifest file pointing to the maf that was just created
		tumor_short_code=`echo $tumor_type | tr '[:upper:]' '[:lower:]'`
		echo -e "$tumor_short_code\t04/02/2015\tUNKNOWN\tfirehose\t$firehose_maf_dir/$tumor_type.maf" >> $firehose_maf_manifest
	fi
done



