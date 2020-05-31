#!/bin/bash
# script will exit with a non-zero code if any command fails
set -e

# Print only the outputs of command not each step
# https://stackoverflow.com/a/36277661/2143801
set +x

# example command to run script:
#sh deployment_scripts/test_build.sh -f eb-docker-nginx-proxy.zip -p eb-docker-nginx-proxy

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

dist_folder_name=dist

# Create source code zip file
rm -rf $PROJECT_NAME/$dist_folder_name
mkdir $PROJECT_NAME/$dist_folder_name
zip -r $PROJECT_NAME/$dist_folder_name/$FILE_NAME $PROJECT_NAME/. -x "*dist*" -x ".DS_Store" -x "__MACOSX"

# List files under $PROJECT_NAME/$dist_folder_name/ folder
echo `pwd`"/$PROJECT_NAME/$dist_folder_name/ folder contains:"
ls -la $PROJECT_NAME/$dist_folder_name

## Compute zip artifact S3 object key with semantic versioning
## Install semver for versioning
#npm install semver@5.4.1
#
## Get the tag with lastest version number from git
#tag_with_latest_version_number=$(git tag -l --sort=-version:refname "${PROJECT_NAME}-${ENVIRONMENT_NAME}-*" | head -n 1)
#echo "Tag with latest version number is: $tag_with_latest_version_number"
#
## Set default tag version number to 0.0.0
#if [ -z "$tag_with_latest_version_number" ]
#then
#      tag_to_increment="${PROJECT_NAME}-${ENVIRONMENT_NAME}-0.0.0"
#else
#      tag_to_increment=$tag_with_latest_version_number
#fi
#echo "Tag name to increment is $tag_to_increment. Increment level is $INCREMENT_LEVEL."
#
## Increment tag version number based on the level selected
#version_number=$(echo $tag_to_increment | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
#new_version=$(./node_modules/.bin/semver $version_number -i $INCREMENT_LEVEL)
#echo "New version number is $new_version"
#
#new_tag_name="${PROJECT_NAME}-${ENVIRONMENT_NAME}-${new_version}"
#echo "New git tag name is $new_tag_name"
#
## Tag git with latest version number
#echo "Trying to tag $new_tag_name"
#git tag "$new_tag_name"
#git push --tags
#echo "Git tag $new_tag_name pushed"
#
## Clean up files under $PROJECT_NAME/$dist_folder_name/ folder
#echo "Deleted "`pwd`"/$PROJECT_NAME/$dist_folder_name/ folder"
#rm -rf $PROJECT_NAME/$dist_folder_name

# Delete git tag
#tag_to_delete=eb-docker-nginx-proxy-development-0.0.1
#echo "Deleting git tag $tag_to_delete"
#git tag -l --sort=-version:refname $tag_to_delete
#git push --delete origin $tag_to_delete
#git tag -d $tag_to_delete
#git tag -l --sort=-version:refname $tag_to_delete
