#!/bin/bash
# script will exit with a non-zero code if any command fails
set -e

# Print only the outputs of command not each step
# https://stackoverflow.com/a/36277661/2143801
set +x

# example command to run script:
#sh deployment_scripts/build_eb_version_zip_artifact.sh -f eb-docker-nginx-proxy.zip -p eb-docker-nginx-proxy

usage(){
    echo "Usage: "
    echo "Build the elasticbeanstalk application version zip artifact. Usage:
$(basename "$0") [-h] [-f -p]
Where:
    -h: Show this usage message.
    -f: Elasticbeanstalk application version zip artifact file name. (eg. eb-docker-nginx-proxy.zip)
    -p: Project folder name. (e.g. eb-docker-nginx-proxy)

"
}

while getopts "hf:p:" opt; do
    case ${opt} in
        h )
            usage
            exit 0
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

# List files under $target_folder_name/ folder
echo `pwd`"/$target_folder_name/ folder contains:"
ls -la $target_folder_name
