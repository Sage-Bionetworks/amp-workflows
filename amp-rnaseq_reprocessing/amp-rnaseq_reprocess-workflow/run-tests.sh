#! /usr/bin/env bash

# This runs tests defined in `tests-descriptions.yaml`. These tests are run
# inside a Docker container to ensure that the right dependencies are in place,
# and any output files and directories are cleaned up afterward.

set -x

IMAGE=amp-rnaseq_reprocess-workflow-tester
WORKDIR=/work

# Build the docker image 
docker build -t $IMAGE .

# Run the cwltest command inside the docker container
docker run --rm -v $(PWD):$WORKDIR -w=$WORKDIR $IMAGE \
  cwltest --test test-descriptions.yaml --tool cwltool
