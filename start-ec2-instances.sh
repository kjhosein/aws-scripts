#!/bin/bash
# Start a list of AWS EC2 instances in a given account and region. 
# Place the list of instance ids in a file specified by the LIST_OF_INSTANCES variable,
#  one (1) per line. 
# In the code below, the file is called "instance-ids.txt" and is in the same dir as this script.
# Assumes the instances has a tag with a key of "Name".
#
# Written by Khalid J Hosein. May 2019.


export AWS_DEFAULT_PROFILE="my-aws-acct1"
export AWS_DEFAULT_REGION="us-east-1"

LIST_OF_INSTANCES="./instance-ids.txt"

while read -r instance_id
do 
    if [[ $instance_id == i* ]]; then
        NAME_TAG=$(aws ec2 describe-tags --filters "Name=key,Values=Name" "Name=resource-id,Values=${instance_id}" --output json | jq -r .Tags[0].Value)

        echo "Starting instance-id ${instance} with Name tag of '${NAME_TAG}' ..."
        aws ec2 start-instances --instance-ids ${instance_id}
        echo
    fi
done < $LIST_OF_INSTANCES
