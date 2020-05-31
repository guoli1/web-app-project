#!/bin/bash
# script will exit with a non-zero code if any command fails
set -e

# Print only the outputs of command not each step
# https://stackoverflow.com/a/36277661/2143801
set +x

# example command to run script:
#sh deployment_scripts/validate_environment_name.sh -e development

usage(){
    echo "Usage: "
    echo "Validate the environment variable ENVIRONMENT_NAME. Usage:
$(basename "$0") [-h] [-e]
Where:
    -h: Show this usage message.
    -e: Environment name. Must be one of development, uat or production.
"
}

while getopts "he:" opt; do
    case ${opt} in
        h )
            usage
            exit 0
          ;;
        e )
            ENVIRONMENT_NAME=$OPTARG
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

if [ -z $ENVIRONMENT_NAME ]; then
  echo "Environment name is a required argument."
  usage
  exit 1
fi

if ! [[ "$ENVIRONMENT_NAME" =~ ^(development|uat|production)$ ]]; then
  echo "Environment name must be one of development, uat or production."
  usage
  exit 1
fi