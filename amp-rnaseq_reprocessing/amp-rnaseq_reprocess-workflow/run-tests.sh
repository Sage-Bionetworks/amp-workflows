#! /usr/bin/env bash

set -x

IMAGE=amp-rnaseq_reprocess-workflow-tester
WORKDIR=/work
docker build -t $IMAGE .
docker run --rm -v $(PWD):$WORKDIR -w=$WORKDIR $IMAGE cwltest --test test-descriptions.yaml --tool cwltool

