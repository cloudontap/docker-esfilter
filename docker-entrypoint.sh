#!/bin/bash

# Populate password file with service credentials for query and data access 
htpasswd -bc /etc/nginx/.htpasswd $DATA_USERNAME  $DATA_PASSWORD 
htpasswd -b  /etc/nginx/.htpasswd $QUERY_USERNAME $QUERY_PASSWORD

# Generate the necessary configuration 
/opt/gosource/startup/esfilter.sh

#this line starts nginx daemon in foreground and should be the last one
/usr/sbin/nginx -g "daemon off;"
