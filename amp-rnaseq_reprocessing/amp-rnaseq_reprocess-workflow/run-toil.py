#! /usr/bin/env python3

import argparse
import atexit
import errno
import json
import logging
import os
import subprocess
import sys

from utils.linkresources import symlink_resources
from utils.unlinkresources import unlink_resources


default_jobdir = 'jobs/default'
default_options_path = 'jobs/default/options.json'
synapse_config_path = './.synapseConfig'

script = os.path.basename(__file__)
log = logging.getLogger(script)
log.setLevel(logging.DEBUG)
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.DEBUG)
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
log.addHandler(handler)


class Options(object):
    fields = [
        'cluster_name',
        'run_name',
        'log_level',
        'retry_count',
        'target_time',
        'default_disk',
        'node_types',
        'max_nodes',
        'node_storage',
        'preemptable_compensation',
        'rescue_frequency',
        'cwl',
        'job_directory',
        'custom_options_path',
        'cwl_args_path',
        'restart',
        'dry_run',
        'jobstore',
        'dest_bucket',
        'log_file',
        'log_path',
        'worker_logs_dir'
    ]

    def __init__(self, options_dict):
        self.__dict__.update(options_dict)

        self.jobstore = 'aws:{}:{}-{}'.format(
            self.zone[:-1], self.cluster_name, self.run_name)
        self.dest_bucket = 's3://{}-out'.format(self.cluster_name)
        self.log_file = '/var/log/toil/{}.log'.format(self.run_name)
        self.log_path = '/var/log/toil/workers/{}'.format(self.run_name)
        self.worker_logs_dir = '/var/log/toil/workers/{}'.format(self.run_name)
        self._validate()
        self.print()

    # Verify all the expected fields are present
    def _validate(self):
        for field in self.fields:
            error_message = 'required option missing: {}'.format(field)
            assert field in self.__dict__, error_message

    # Print all fields
    def print(self):
        log.debug('OPTIONS:')
        for key, value in self.__dict__.items():
            log.debug('{} = {}'.format(key, value))


class ToilCommand:
    def __init__(self, options):
        self.options = options

    def run(self):
        command_str = ' '.join(self.command)
        if self.options.dry_run:
            log.info('TOIL COMMAND DRY RUN: {}'.format(command_str))
        else:
            log.info('RUNNING TOIL COMMAND: {}'.format(command_str))
            subprocess.call(self.command)


class ToilCleanCommand(ToilCommand):
    def __init__(self, options):
        super().__init__(options)
        self.command = ['toil', 'clean', options.jobstore]


class ToilRunCommand(ToilCommand):
    provisioner = 'aws'
    batch_system = 'mesos'

    def __init__(self, options):
        super().__init__(options)
        # Set environment variables necessary to toil
        os.environ['TOIL_AWS_ZONE'] = options.zone
        os.environ['TMPDIR'] = options.tmpdir

        self.command = [
            'toil-cwl-runner',
            '--provisioner', 'aws',
            '--batchSystem', 'mesos',
            '--jobStore', options.jobstore,
            '--logLevel', options.log_level,
            '--logFile', options.log_file,
            '--writeLogs', options.worker_logs_dir,
            '--retryCount', options.retry_count,
            '--metrics',
            '--runCwlInternalJobsOnWorkers',
            '--targetTime', options.target_time,
            '--defaultDisk', options.default_disk,
            '--nodeTypes', options.node_types,
            '--maxNodes', options.max_nodes,
            '--nodeStorage', options.node_storage,
            '--destBucket', options.dest_bucket,
            '--rescueJobsFrequency', options.rescue_frequency
        ]
        # Add some options only if node_types contains the spot syntax
        if options.node_types.find(':') > -1:
            self.command.extend([
                '--defaultPreemptable',
                '--preemptableCompensation', options.preemptable_compensation
            ])

        if options.restart:
            self.command.append('--restart')

        # Finally, add the cwl file and its arguments file
        self.command.extend([options.cwl, options.cwl_args_path])


def parse_args():
    description = (
        'run-toil.py will run a cwl workflow with configuration-driven options.'
        'Run example: ./run-toil.py --dry-run jobs/test-main-paired'
        'Run ./run-toil.py -h for more information, or see the README'
        'in this directory.'
        )
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument(
        'job_directory',
        help='Directory containing options.json and requirements files')
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        '--clean',
        help='Clean (remove) the jobstore, and start the job fresh',
        action='store_true')
    group.add_argument(
        '--restart',
        help='Restart a job that was previously interrupted',
        action='store_true')
    parser.add_argument(
        '--dry-run',
        help='Show the toil command that would be run, but don\'t run it',
        action='store_true')
    return parser.parse_args()


def directory_exists(dir_path):
    error_message = 'directory missing: {}'.format(dir_path)
    test = os.path.exists(dir_path) and not os.path.isfile(dir_path)
    assert test, error_message


def file_exists(file_path):
    error_message = 'file missing: {}'.format(file_path)
    test = os.path.exists(file_path) and os.path.isfile(file_path)
    assert test, error_message


# Validate directories and files are present
def validate_paths(job_directory, custom_options_path, cwl_args_path):
    directory_exists(job_directory)
    file_exists(custom_options_path)
    file_exists(cwl_args_path)


def make_log_directories(log_path):
    log.debug('Making log directories: {}'.format(log_path))
    try:
        os.makedirs(log_path)
        log.debug('Path {} created.'.format(log_path))
    except OSError as e:
        if e.errno == errno.EEXIST:
            log.warning('Directory {} already exists.'.format(log_path))
        else:
            raise


def get_opts(default_options_path, args):
    job_directory = args.job_directory
    custom_options_path = '{}/options.json'.format(job_directory)
    cwl_args_path = '{}/job.json'.format(job_directory)

    validate_paths(job_directory, custom_options_path, cwl_args_path)

    # load default options
    with open(default_options_path) as json_file:
        opts = json.load(json_file)

    # load custom options
    with open(custom_options_path) as json_file:
        custom_opts = json.load(json_file)

    # merge custom options into defaults
    opts.update(custom_opts)

    # Add argument-based options
    opts['job_directory'] = job_directory
    opts['custom_options_path'] = custom_options_path
    opts['cwl_args_path'] = cwl_args_path
    opts['restart'] = args.restart
    opts['dry_run'] = args.dry_run

    return Options(opts)


def main():
    args = parse_args()

    # Get the options object
    options = get_opts(default_options_path, args)

    # Validate that the specified cwl file exists
    file_exists(options.cwl)

    # Validate that the .synapseConfig file is present
    file_exists(synapse_config_path)

    # Clean jobstore
    if args.clean:
        ToilCleanCommand(options).run()

    # Make directories for main and worker logs
    make_log_directories(options.log_path)

    # symlink resource files to script directory
    links = symlink_resources(options.job_directory)
    atexit.register(unlink_resources, links)

    # Run the toil job
    ToilRunCommand(options).run()


main()
