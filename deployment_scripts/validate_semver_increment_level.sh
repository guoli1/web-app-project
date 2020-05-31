#!/bin/bash
# script will exit with a non-zero code if any command fails
set -e

# Print only the outputs of command not each step
# https://stackoverflow.com/a/36277661/2143801
set +x

# example command to run script:
#sh deployment_scripts/validate_semver_increment_level.sh -i patch

usage(){
    echo "Usage: "
    echo "Validate the environment variable INCREMENT_LEVEL. Usage:
$(basename "$0") [-h] [-i]
Where:
    -h: Show this usage message.
    -i: Increment level for semantic versioning on the latest version number. Must be one of major, minor, or patch.
"
}

while getopts "hi:" opt; do
    case ${opt} in
        h )
            usage
            exit 0
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

if [ -z $INCREMENT_LEVEL ]; then
  echo "Semantic version increment level is a required argument."
  usage
  exit 1
fi

if ! [[ "$INCREMENT_LEVEL" =~ ^(major|minor|patch)$ ]]; then
  echo "Semantic version increment level must be one of major, minor or patch."
  usage
  exit 1
fi