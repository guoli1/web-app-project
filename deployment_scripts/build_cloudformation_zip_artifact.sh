#!/bin/bash
# script will exit with a non-zero code if any command fails
set -e

# Print only the outputs of command not each step
# https://stackoverflow.com/a/36277661/2143801
set +x

# example command to run script:
#sh deployment_scripts/build_cloudformation_zip_artifact.sh -c cf-bundle.zip

usage(){
    echo "Usage: "
    echo "Build the cloudformation files zip artifact. Usage:
$(basename "$0") [-h] [-c]
Where:
    -h: Show this usage message.
    -c: CloudFormation template and configuration file zip artifact file name. (e.g. cf-bundle.zip)
"
}

while getopts "hc:" opt; do
    case ${opt} in
        h )
            usage
            exit 0
          ;;
        c )
            CLOUDFORMATION_FILE_NAME=$OPTARG
          ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            usage
            exit 1
          ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            usage
            exit 1
          ;;
    esac
done


if [ -z "$CLOUDFORMATION_FILE_NAME" ]; then
  echo "Cloudformation template and configuration zip file name is a required argument."
  usage
  exit 1
fi

target_folder_name=target

# Create target directory
rm -rf $target_folder_name
mkdir $target_folder_name

# Create cloudformation template and configuration zip file
cd cf_templates
zip -r ../$target_folder_name/$CLOUDFORMATION_FILE_NAME . -x ".DS_Store" -x "__MACOSX"
cd ..

# List files under $target_folder_name/ folder
echo `pwd`"/$target_folder_name/ folder contains:"
ls -la $target_folder_name
