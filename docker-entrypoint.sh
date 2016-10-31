#!/bin/bash

# Determine the region
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${REGION::-1}

# Decrypt passwords
echo $DATA_PASSWORD  | base64 -d > data_password.bin
echo $QUERY_PASSWORD | base64 -d > query_password.bin

DATA_PASSWORD_PLAINTEXT=$(aws --region ${REGION} --output text kms decrypt \
            --query Plaintext \
            --ciphertext-blob "fileb://data_password.bin" | base64 -d)

QUERY_PASSWORD_PLAINTEXT=$(aws --region ${REGION} --output text kms decrypt \
            --query Plaintext \
            --ciphertext-blob "fileb://query_password.bin" | base64 -d)

echo $DATA_USERNAME=$DATA_PASSWORD_PLAINTEXT
echo $QUERY_USERNAME=$QUERY_PASSWORD_PLAINTEXT

# Populate password file with service credentials for query and data access 
htpasswd -bc /etc/nginx/.htpasswd $DATA_USERNAME  $DATA_PASSWORD_PLAINTEXT
htpasswd -b  /etc/nginx/.htpasswd $QUERY_USERNAME $QUERY_PASSWORD_PLAINTEXT

# Generate the necessary configuration 
/opt/gosource/startup/esfilter.sh

#this line starts nginx daemon in foreground and should be the last one
/usr/sbin/nginx -g "daemon off;"
