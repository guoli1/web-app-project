#!/bin/bash
# script will exit with a non-zero code if any command fails
set -e

# Print only the outputs of command not each step
# https://stackoverflow.com/a/36277661/2143801
set +x

# example command to run script:
#sh deployment_scripts/build_zip_artifacts.sh -c cf-bundle.zip -f eb-docker-nginx-proxy.zip -p eb-docker-nginx-proxy

usage(){
    echo "Usage: "
    echo "Build the elasticbeanstalk application version and cloudformation files zip artifacts. Usage:
$(basename "$0") [-h] [-c -f -p]
Where:
    -h: Show this usage message.
    -c: CloudFormation template and configuration file zip artifact file name. (e.g. cf-bundle.zip)
    -f: Elasticbeanstalk application version zip artifact file name. (eg. eb-docker-nginx-proxy.zip)
    -p: Project folder name. (e.g. eb-docker-nginx-proxy)

"
}

while getopts "hc:f:p:" opt; do
    case ${opt} in
        h )
            usage
            exit 0
          ;;
        c )
            CLOUDFORMATION_FILE_NAME=$OPTARG
          ;;
        f )
            FILE_NAME=$OPTARG
          ;;
        p )
            PROJECT_NAME=$OPTARG
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

if [ -z "$FILE_NAME" ]; then
  echo "Elasticbeanstalk application version zip file name is a required argument."
  usage
  exit 1
fi
if [ -z "$PROJECT_NAME" ]; then
  echo "Project folder name is a required argument."
  usage
  exit 1
fi

target_folder_name=target

# Create target directory
rm -rf $target_folder_name
mkdir $target_folder_name

# Create elasticbeanstalk version source code zip file
cd $PROJECT_NAME
zip -r ../$target_folder_name/$FILE_NAME . -x ".DS_Store" -x "__MACOSX"
cd ..

# Create cloudformation template and configuration zip file
cd cf_templates
zip -r ../$target_folder_name/$CLOUDFORMATION_FILE_NAME . -x ".DS_Store" -x "__MACOSX"
cd ..

# List files under $target_folder_name/ folder
echo `pwd`"/$target_folder_name/ folder contains:"
ls -la $target_folder_name
