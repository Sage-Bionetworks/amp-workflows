#!/usr/bin/env python
# JAE for Sage Bionetworks
# February 24, 2017
"""
Script to combine Picard metrics from multiple tools for the same sample.
"""
import logging
import sys
import re
import csv
import argparse

logger = logging.getLogger(__name__)


def read_file(path):
    """
    Read lines from a file and return as list.
    """
    logger.debug("reading file {}".format(path))
    with open(path) as f:
        return f.readlines()


def get_metrics_lines(lines):
    """
    Return subset of lines corresponding to relevant metrics data.
    """
    metrics_start = [idx for idx, l in enumerate(lines)
                     if re.search('^## METRICS CLASS', l)][0]
    metrics_end = metrics_start + 3
    return lines[metrics_start:metrics_end]


def parse_metrics(lines):
    """
    Parse metrics data into key-value pairs.
    """
    metrics_class = lines[0].strip().split('.')[-1]
    metric_names = ['{}__{}'.format(metrics_class, n)
                    for n in lines[1].strip().split('\t')]
    metric_vals = [float(v) if not re.search(r'[^\d.]+', v)
                   else v
                   for v in lines[2].strip().split('\t')]
    return dict(zip(metric_names, metric_vals))


def combine_metrics(metrics_data):
    """
    Merge all metrics dictionaries in list into a single object.
    """
    combined_metrics = metrics_data[0]
    for d in metrics_data[1:]:
        combined_metrics.update(d)
    return combined_metrics


def main(argv):
    """
    Combine data from one or more Picard metrics outputs into a
    single CSV table.
    """
    logging.basicConfig(level=logging.DEBUG)

    parser = argparse.ArgumentParser()
    parser.add_argument('--output', '-o',
                        help='path to output CSV file')
    parser.add_argument('paths', nargs='+',
                        help='input paths, separated by spaces')

    args = parser.parse_args()
    metrics_data = [parse_metrics(get_metrics_lines(read_file(p)))
                    for p in args.paths]
    if args.output is not None:
        with open(args.output, 'w') as csvfile:
            combined_metrics = combine_metrics(metrics_data)
            field_names = sorted(combined_metrics.keys())
            writer = csv.DictWriter(csvfile, field_names)
            writer.writeheader()
            writer.writerow(combined_metrics)
    else:
        print(combine_metrics(metrics_data))


if __name__ == "__main__":
    main(sys.argv[1:])
