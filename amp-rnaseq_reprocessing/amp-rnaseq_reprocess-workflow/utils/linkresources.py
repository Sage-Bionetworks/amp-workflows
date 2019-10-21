#! /usr/bin/env python3

"""Link Resources

Create symlinks to resource files in default and job directories.
"""

import argparse
import os


default_jobdir = 'jobs/default'


def get_resource_files(dir_path):
    """Finds resource files in a given directory."""
    return {
        filename: '{}/{}'.format(dir_path, filename)
        for filename in os.listdir(dir_path)
        if filename.startswith('resource')
        }


def symlink_resources(job_directory):
    """Create symlinks for resource files in the current directory. Chooses
    any resource files found in job_directory over default_jobdir, effectively
    overriding the defaults."""
    resources = get_resource_files(default_jobdir)
    resources.update(get_resource_files(job_directory))
    cur_dir = os.curdir
    for filename, src_path in resources.items():
        os.symlink(src_path, filename)
    return ['{}/{}'.format(cur_dir, key) for key in resources.keys()]


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        'job_directory',
        help='Directory containing requirements files')
    args = parser.parse_args()
    links = symlink_resources(args.job_directory)
    print(' '.join(links))


if __name__ == '__main__':
    main()
