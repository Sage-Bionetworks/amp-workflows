#! /usr/bin/env python3

import argparse
import os


# Find resource files in a given directory
def get_resource_files(dir_path):
    return {
        filename: '{}/{}'.format(dir_path, filename)
        for filename in os.listdir(dir_path)
        if filename.startswith('resource')
        }


# Create symlinks to resource files in default and job directories
# Register handler to remove the symlinks when script exits.
def symlink_resources(job_directory):
    resources = get_resource_files('jobs/default')
    resources.update(get_resource_files(job_directory))
    cur_dir = os.curdir
    for filename, src_path in resources.items():
        os.symlink(src_path, filename)
    return ['{}/{}'.format(cur_dir, key) for key in resources.keys()]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'job_directory',
        help='Directory containing requirements files')
    args = parser.parse_args()
    links = symlink_resources(args.job_directory)
    print(' '.join(links))


if __name__ == '__main__':
    main()
