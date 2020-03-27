#! /usr/bin/env python3

"""Unlink Resources

Remove symlinks to resource files.
"""

import argparse
import os


def unlink_resources(links):
    """Unlink the links, an array of filepaths."""
    if links:
        for link in links:
            os.unlink(link)
    else:
        print('No symlinks supplied to unlink')


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        'links',
        nargs='+',
        help='Symlinks to unlink')
    args = parser.parse_args()
    unlink_resources(args.links)


if __name__ == '__main__':
    main()
