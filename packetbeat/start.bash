#/bin/bash

if [ -z "${CONF}" ]; then
	export CONF="packetbeat.yml"
fi

#sed -i "s,PROD_INSTALL,${PROD_INSTALL},g" ${PROD_INSTALL}/${CONF}
if [ ! -z "${ELASTICSEARCH_URL}" ]; then
	sed -i "s,localhost:9200,${ELASTICSEARCH_URL}," ${PROD_INSTALL}/${CONF}
fi

${PROD_INSTALL}/packetbeat 

