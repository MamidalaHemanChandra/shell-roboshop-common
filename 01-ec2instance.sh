#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-08f60881e2f01df0a"
ZONE_ID="Z00303221M2EO78HUMVX6"
DOMAIN_NAME="heman.icu"

for instance in $@
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id "$AMI_ID" --instance-type t3.micro --security-group-ids "$SG_ID" --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

    if [ $instance != "frontend" ];then
        IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    fi

    aws route53 change-resource-record-sets \
        --hosted-zone-id "$ZONE_ID" \
        --change-batch '{
            "Changes": [{
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "'"$instance.$DOMAIN_NAME"'",
                "Type": "A",
                "TTL": 1,
                "ResourceRecords": [
                { "Value": "'"$IP"'" }
                ]
            }
            }]
        }'

    echo "$instance=$IP"
done