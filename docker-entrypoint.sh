#!/bin/bash

# Generate the necessary configuration
/opt/gosource/startup/esfilter.sh

#this line starts nginx daemon in foreground and should be the last one
/usr/sbin/nginx -g "daemon off;"
