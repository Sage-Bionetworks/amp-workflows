#! /usr/bin/env python

import boto3
import datetime
import os
import subprocess
import errno
import logging
import sys

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

# The first section of this script deals with creating a bid

# for the majority of our worker nodes.
ondemand = 0.768
instance_type = "m5.4xlarge"
region = "us-east-1"
zone = "us-east-1a"
last_week = (datetime.datetime.now() - datetime.timedelta(days=7)).isoformat()

client = boto3.client('ec2', region_name=region)
response = client.describe_spot_price_history(
        AvailabilityZone=zone,
        InstanceTypes=[instance_type],
        StartTime=last_week,
        ProductDescriptions=["Linux/UNIX"]

)

prices = [h["SpotPrice"] for h in response.get("SpotPriceHistory")]

max_price = max(prices)

ratio_of_max = 1.1  # nudge bid slightly over max to ensure we obtain nodes
our_bid = float(max_price) * ratio_of_max
our_bid = our_bid if our_bid < ondemand else ondemand

logging.info("Our bid is {}, {}%% of the maximum bid of {} over the last week."
  .format(our_bid, int(ratio_of_max * 100.0), max_price))

# Set environment variables necessary to toil.
os.environ["TOIL_AWS_ZONE"] = "us-east-1a"
os.environ["TMPDIR"] = "/var/lib/toil"


# Pick a cluster. This could be a script argument.
#cluster_name = "rna-seq-reprocessing-toil-cluster-v001"           # sandbox
cluster_name = "rna-seq-reprocessing-scicomp-toil-cluster-v001"  # scicomp

# Toil options
run_name = "ros"
jobstore = "aws:us-east-1:{}-{}".format(cluster_name, run_name)
dest_bucket = "s3://{}-out".format(cluster_name)
log_level = "DEBUG"
log_file = "/var/log/toil/{}.log".format(run_name)
log_path = "/var/log/toil/workers/{}".format(run_name)
worker_logs_dir = "/var/log/toil/workers/{}".format(run_name)
retry_count = "5"
target_time = "1"  # this makes autoscaling aggressive
default_disk = "450G"  # is this necessary if we use destBucket?
node_types = "m5.12xlarge,m5.4xlarge:{}".format(our_bid)
max_nodes = "1,25"
node_storage = "500"
preemptable_compensation = "0.5"
rescue_frequency = "9000"

# Clean jobstore. Comment this out if you plan to add restart below.

logging.info("Cleaning up jobstore")

subprocess.call(["toil", "clean", jobstore])

# Make log directories.
logging.info("Making log directories: {}".format(log_path))
try:
    os.makedirs(log_path)
    logging.info("Path {} created.".format(log_path))
except OSError as e:
    if e.errno == errno.EEXIST:
        logging.warn("Directory {} already exists.".format(log_path))
    else:
        raise
# Run toil job.
logging.info("Running new toil job")
subprocess.check_output(["toil-cwl-runner",
  "--provisioner", "aws",
  "--batchSystem", "mesos",
  "--jobStore", jobstore,
  "--logLevel", log_level,
  "--logFile", log_file,
  "--writeLogs", worker_logs_dir,
  "--retryCount", retry_count,
  "--metrics",
  #"--runCwlInternalJobsOnWorkers",
  "--targetTime", target_time,
  "--defaultDisk", default_disk,
  "--nodeTypes", node_types,
  "--maxNodes", max_nodes,
  "--nodeStorage", node_storage,
  "--destBucket", dest_bucket,
  "--defaultPreemptable",
  "--disableChaining",
  "--preemptableCompensation", preemptable_compensation,
  "--rescueJobsFrequency", rescue_frequency,
  #"--restart",
  "main-paired-get-index.cwl", "main.json"
])
