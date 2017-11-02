#!/usr/bin/dumb-init /bin/bash

if [ -z "${CONF}" ]; then
	export CONF="filebeat.yml"
fi

#sed -i "s,PROD_INSTALL,${PROD_INSTALL},g" ${PROD_INSTALL}/${CONF}
if [ ! -z "${ELASTICSEARCH_URL}" ]; then
	sed -i "s,localhost:9200,${ELASTICSEARCH_URL}," ${PROD_INSTALL}/${CONF}
fi

${PROD_INSTALL}/filebeat -f ${PROD_INSTALL}/${CONF}

