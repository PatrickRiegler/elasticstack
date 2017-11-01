#!/usr/bin/dumb-init /bin/bash

if [ -z "${CONF}" ]; then
	export CONF="config/logstash.conf"
fi

ls -lia ${PROD_INSTALL}/
ls -lia ${PROD_INSTALL}/config/
ls -lia ${PROD_INSTALL}/${CONF}
cat ${PROD_INSTALL}/${CONF}


if [ ! -z "${ELASTICSEARCH_URL}" ]; then
	sed -i "s,ELASTICSEARCH_URL,${ELASTICSEARCH_URL}," ${PROD_INSTALL}/${CONF}
fi
if [ ! -z "${ELASTICSEARCH_HOST}" ]; then
	sed -i "s,ELASTICSEARCH_HOST,${ELASTICSEARCH_HOST}," ${PROD_INSTALL}/${CONF}
if [ ! -z "${ELASTICSEARCH_PATH}" ]; then
	sed -i "s,ELASTICSEARCH_PATH,${ELASTICSEARCH_PATH}," ${PROD_INSTALL}/${CONF}
else
	sed -i "s,ELASTICSEARCH_PATH,/," ${PROD_INSTALL}/${CONF}
fi
sed -i "s,PROD_INSTALL,${PROD_INSTALL}," ${PROD_INSTALL}/${CONF}
if [ ! -z "${LS_INDEXNAME}" ]; then
	sed -ri "s,LS_INDEXNAME,${LS_INDEXNAME}," ${PROD_INSTALL}/${CONF}
fi

if [ "$AUTOLOGGER" = "true" ]; then
(while true; do  echo "$(date +"%Y%m%d%H%M%S")|4|REQUEST|10.16.5.206|tkr6q|GET|/get/$(date +"%Y%m%d")/$(echo $((RANDOM%20+10)))|HTTP/1.1|200|0" >> ${PROD_INSTALL}/request.log; sleep ${SLEEP}; done) &
fi

exec ${PROD_INSTALL}/bin/logstash -f ${PROD_INSTALL}/${CONF}
