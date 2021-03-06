#!/bin/bash
# script will exit with a non-zero code if any command fails
set -e

# Print only the outputs of command not each step
# https://stackoverflow.com/a/36277661/2143801
set +x

# example command to run script:
#sh deployment_scripts/get_incremented_build_version.sh -p eb-docker-nginx-proxy

usage(){
    echo "Usage: "
    echo "Get the Git tag with the latest semantic version number and increment it based on the level selected. Usage:
$(basename "$0") [-h] [-e -p -i]
Where:
    -h: Show this usage message.
    -e: Environment name. Must be one of development, uat or production. (default: development)
    -p: Project folder name. (e.g. eb-docker-nginx-proxy)
    -i: Increment level for semantic versioning on the latest version number. Must be one of major, minor, or patch. (default: patch)
"
}

ENVIRONMENT_NAME=development
INCREMENT_LEVEL=patch

while getopts "he:p:i:" opt; do
    case ${opt} in
        h )
            usage
            exit 0
          ;;
        e )
            ENVIRONMENT_NAME=$OPTARG
          ;;
        p )
            PROJECT_NAME=$OPTARG
          ;;
        i )
            INCREMENT_LEVEL=$OPTARG
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

if ! [[ "$ENVIRONMENT_NAME" =~ ^(development|uat|production)$ ]]; then
  echo "Environment name must be one of development, uat or production."
  usage
  exit 1
fi

if [ -z "$PROJECT_NAME" ]; then
  echo "Project folder name is a required argument."
  usage
  exit 1
fi

if ! [[ "$INCREMENT_LEVEL" =~ ^(major|minor|patch)$ ]]; then
  echo "Semantic version increment level must be one of major, minor or patch."
  usage
  exit 1
fi

# Get the tag with lastest version number from git
tag_with_latest_version_number=$(git tag -l --sort=-version:refname "${PROJECT_NAME}-${ENVIRONMENT_NAME}-*" | head -n 1)
echo "Tag with latest version number is: $tag_with_latest_version_number"

# Set default tag version number to 0.0.0
if [ -z "$tag_with_latest_version_number" ]
then
      tag_to_increment="${PROJECT_NAME}-${ENVIRONMENT_NAME}-0.0.0"
else
      tag_to_increment=$tag_with_latest_version_number
fi
echo "Tag name to increment is $tag_to_increment. Increment level is $INCREMENT_LEVEL."

# Increment tag version number based on the level selected
version_number=$(echo $tag_to_increment | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
NEW_VERSION=$(semver $version_number -i $INCREMENT_LEVEL)
echo "New version number is $NEW_VERSION"
echo ${NEW_VERSION} > incrementedVersion.txt

NEW_TAG_NAME="${PROJECT_NAME}-${ENVIRONMENT_NAME}-${NEW_VERSION}"
echo "New git tag name is $NEW_TAG_NAME"
echo ${NEW_TAG_NAME} > incrementedTagName.txt