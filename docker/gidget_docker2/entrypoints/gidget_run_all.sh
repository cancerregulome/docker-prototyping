#!/bin/bash

# Parse args
user_found=false
maf_manifest_found=false
output_dir_found=false

while [[ $# > 0 ]]; do
	option="$1"
	
	case $option in
		-u|--user)
		USER="$2"
		user_found=true
		shift
		;;
		-i|--maf-manifest)
		INPUT_FILE="$2"
		maf_manifest_found=true
		shift
		;;
		-o|--output-dir)
		OUTPUT_DIR="$2"
		output_dir_found=true
		shift
		;;
		-c|--config)
		CONFIG_FILE="$2"
		shift
		;;
		--stop-at)
		STOP_AT="--stop-at=$2"
		shift
		;;
		*)
		
		;;
	esac
	shift
done

if [[ "$user_found" = false ]]; then
	echo "Usage: -u <username> required."
	exit
elif [[ "$maf_manifest_found" = false ]]; then
	echo "Usage: -i <input-maf-manifest> required"
	exit
elif [[ "$output_dir_found" = false ]]; then
	echo "Usage: -o <output-dir> required"
fi

if [ -z "$CONFIG_FILE" ]; then
	echo "Using default configuration..."
	cat /gidget/config/gidget.config
	CONFIG_FILE=/gidget/config/gidget.config
fi

# configure automount
./entrypoints/automount_setup.sh

# Setup gidget
chown -R $USER /gidget

# Run gidget
su -c "PYTHONPATH=/usr/local/lib/python2.7:/usr/local/lib/python3.4:/gidget/commands/maf_processing/python:/gidget/commands/maf_processing/python/archive:/gidget/commands/feature_matrix_construction/main:/gidget/commands/feature_matrix_construction/main/archive:/gidget/commands/feature_matrix_pipeline/util python /gidget/gidget/gidget_run_all.py $STOP_AT --config=$CONFIG_FILE $INPUT_FILE $OUTPUT_DIR" $USER
