#! /usr/bin/env python3

import argparse
import datetime
import json
import sys
from pkg_resources import resource_filename

import boto3


def get_bid(session, instance_type, zone, ratio):
    region = zone[:-1]

    # get the start time for a week ago, as a week's worth of prices
    # will be pulled to determine a max
    last_week = (datetime.datetime.now() - datetime.timedelta(days=7)).isoformat()

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
    price = get_price(session, region, instance_type, 'Linux').rstrip('0')

    print(
        'Based on ratio of {}, the recommended bid is {}.'
        .format(ratio, our_bid))
    print(
        'For comparision, the on-demand price is {}.'
        .format(price))


# The code below for obtaining the on-demand price was adapted from
# https://stackoverflow.com/questions/51673667

# Search product filter
FLT = '[{{"Field": "tenancy", "Value": "shared", "Type": "TERM_MATCH"}},'\
      '{{"Field": "operatingSystem", "Value": "{o}", "Type": "TERM_MATCH"}},'\
      '{{"Field": "preInstalledSw", "Value": "NA", "Type": "TERM_MATCH"}},'\
      '{{"Field": "instanceType", "Value": "{t}", "Type": "TERM_MATCH"}},'\
      '{{"Field": "capacitystatus", "Value": "Used", "Type": "TERM_MATCH"}},'\
      '{{"Field": "location", "Value": "{r}", "Type": "TERM_MATCH"}}]'


# Get current AWS price for an on-demand instance
def get_price(session, region, instance, os):
    pricing = session.client('pricing', region_name='us-east-1')
    region_name = get_region_name(region)
    f = FLT.format(r=region_name, t=instance, o=os)
    data = pricing.get_products(ServiceCode='AmazonEC2', Filters=json.loads(f))
    od = json.loads(data['PriceList'][0])['terms']['OnDemand']
    id1 = list(od)[0]
    id2 = list(od[id1]['priceDimensions'])[0]
    return od[id1]['priceDimensions'][id2]['pricePerUnit']['USD']


# Translate region code to region name
def get_region_name(region_code):
    default_region = 'US East (N. Virginia)'
    endpoint_file = resource_filename('botocore', 'data/endpoints.json')
    try:
        with open(endpoint_file, 'r') as f:
            data = json.load(f)
        return data['partitions'][0]['regions'][region_code]['description']
    except IOError:
        return default_region


def main():

    if sys.version_info < (3, 2):
        raise RuntimeError('This script requres Python 3.2+')

    parser = argparse.ArgumentParser()
    parser.add_argument(
        'instance_type',
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

    session = boto3.Session(profile_name=args.aws_profile)

    get_bid(
        session=session,
        zone=args.zone,
        instance_type=args.instance_type,
        ratio=args.ratio)


main()
