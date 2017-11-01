#!/usr/bin/dumb-init /bin/bash

if [ "${ELASTICSEARCH_URL}" != "" ]; then
  sed -ri "s,elasticsearch.url:.*,elasticsearch.url: ${ELASTICSEARCH_URL}," ${PROD_INSTALL}/config/kibana.yml
fi

${PROD_INSTALL}/bin/kibana ${STARTUP_PARAMS}
