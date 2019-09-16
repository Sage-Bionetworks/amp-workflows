#! /usr/bin/env python3

import argparse
import datetime
import sys

import boto3
import ondemand

if sys.version_info < (3, 2):
    raise RuntimeError('This script requres Python 3.2+')

parser = argparse.ArgumentParser()
parser.add_argument(
    'instance-type',
    help='Directory containing options.json and requirements files')
parser.add_argument(
    '--zone',
    help='The aws zone for the bid instance type',
    default='us-east-1a')
parser.add_argument(
    '--ratio',
    help='Ratio of max used to determine the recommended bid',
    default=1.1)
parser.add_argument(
    '--aws-profile',
    help='AWS user profile to use when making boto3 requests')
args = parser.parse_args()

instance_type = getattr(args, 'instance-type')
zone = args.zone
region = zone[:-1]
ratio = args.ratio
profile = args.aws_profile

# get the start time for a week ago, as a week's worth of prices
# will be pulled to determine a max
last_week = (datetime.datetime.now() - datetime.timedelta(days=7)).isoformat()

session = boto3.Session(profile_name=profile)
ec2 = session.client('ec2', region_name=region)
response = ec2.describe_spot_price_history(
        AvailabilityZone=zone,
        InstanceTypes=[instance_type],
        StartTime=last_week,
        ProductDescriptions=['Linux/UNIX']
)

prices = [h['SpotPrice'] for h in response.get('SpotPriceHistory')]

max_price = max(prices)

our_bid = float(max_price) * ratio
price = ondemand.get_price(session, region, instance_type, 'Linux').rstrip('0')

print('Based on ratio of {}, the recommended bid is {}.'.format(ratio, our_bid))
print('For comparision, the on-demand price is {}.'.format(price))
