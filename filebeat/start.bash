#/bin/bash

if [ -z "${CONF}" ]; then
	export CONF="filebeat.yml"
fi

#sed -i "s,PROD_INSTALL,${PROD_INSTALL},g" ${PROD_INSTALL}/${CONF}
if [ ! -z "${ELASTICSEARCH_URL}" ]; then
	sed -i "s,localhost:9200,${ELASTICSEARCH_URL}," ${PROD_INSTALL}/${CONF}
fi

if [ "$AUTOLOGGER" = "true" ]; then
sed -ri "s,/var/log/.*,$PROD_INSTALL/request.log," $PROD_INSTALL/${CONF}
(while true; do  echo "$(date +"%Y%m%d%H%M%S")|4|REQUEST|10.16.5.206|tkr6q|GET|/get/$(date +"%Y%m%d")/$(echo $((RANDOM%20+10)))|HTTP/1.1|200|0" >> ${PROD_INSTALL}/request.log; sleep ${SLEEP}; done) &
fi

${PROD_INSTALL}/filebeat 

