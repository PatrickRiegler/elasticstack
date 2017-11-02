#!/usr/bin/dumb-init /bin/bash

#if [ -z "${CONF}" ]; then
#	export CONF="config/filebeat"
#fi

#sed -i "s,PROD_INSTALL,${PROD_INSTALL},g" ${PROD_INSTALL}/${CONF}
#if [ ! -z "${ELASTICSEARCH_URL}" ]; then
#	sed -i "s,ELASTICSEARCH_URL,${ELASTICSEARCH_URL}," ${PROD_INSTALL}/${CONF}
#fi

${PROD_INSTALL}/bin/filebeat -f ${PROD_INSTALL}/${CONF}

