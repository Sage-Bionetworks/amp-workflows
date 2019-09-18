#! /usr/bin/env python3

import argparse
import os


def unlink_resources(links):
    if links:
        for link in links:
            os.unlink(link)
    else:
        print('No symlinks supplied to unlink')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'links',
        nargs='+',
        help='Symlinks to unlink')
    args = parser.parse_args()
    unlink_resources(args.links)


if __name__ == '__main__':
    main()
