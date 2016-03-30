#!/bin/bash

# Stuff that should already be in the image
GOSOURCE_STARTUP=/opt/gosource/startup
GOSOURCE_ESFILTER=/opt/gosource/startup/esfilter

# Location to put config files
NGINX_CONFIG=/etc/nginx

# Save the configuration to a file
CONFIG_FILE=/tmp/config.json
echo ${CONFIGURATION} > ${CONFIG_FILE}

# Create the ip lists
for LIST in data query; do
	# Generate the logstash configuration file
	VARIABLES=""
	VARIABLES="${VARIABLES} -v configuration=${CONFIG_FILE}"
	VARIABLES="${VARIABLES} -v list=${LIST}"
	
	# Generate the logstash configuration for loading data to elasticsearch
	java -jar ${GOSOURCE_STARTUP}/gsgen.jar -i ip_list.ftl -d ${GOSOURCE_ESFILTER} -o ${NGINX_CONFIG}/ip_${LIST}.conf $VARIABLES
done

# Now the top level nginx configuration
VARIABLES=""
VARIABLES="${VARIABLES} -v CONFIGURATION=${CONFIG_FILE}"

java -jar ${GOSOURCE_STARTUP}/gsgen.jar -i nginx.ftl -d ${GOSOURCE_ESFILTER} -o ${NGINX_CONFIG}/nginx.conf $VARIABLES

