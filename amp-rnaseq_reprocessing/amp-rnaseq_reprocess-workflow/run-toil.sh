#! /usr/bin/env bash

set -x

export TOIL_AWS_ZONE=us-east-1a
export TMPDIR=/var/lib/toil

JOBSTORE=aws:us-east-1:rna-seq-reprocessing-toil-cluster-v001-rna

toil clean $JOBSTORE

mkdir -p /var/log/toil/workers/rna

toil-cwl-runner --provisioner aws \
--jobStore $JOBSTORE \
--provisioner aws \
--batchSystem mesos \
--logLevel DEBUG \
--logFile /var/log/toil/rna.log \
--disableCaching \
--retryCount 1 \
--metrics \
--runCwlInternalJobsOnWorkers \
--targetTime 1 \
--defaultDisk 80G \
--nodeTypes m5.2xlarge \
--nodeStorage 100 \
--maxNodes 10 \
--writeLogs /var/log/toil/workers/rna \
main-paired.cwl main.json
