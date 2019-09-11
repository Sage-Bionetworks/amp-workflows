#! /usr/bin/env bash

# This runs tests defined in `tests-descriptions.yaml`. These tests are run
# inside a Docker container to ensure that the right dependencies are in place,
# and any output files and directories are cleaned up afterward.

set -x

IMAGE=amp-rnaseq_reprocess-workflow-tester
WORKDIR=/work

docker build -t $IMAGE .

docker run \
  --rm \
  -v "$(pwd)":$WORKDIR \
  -w=$WORKDIR \
  $IMAGE \
  ./run-tests.py
