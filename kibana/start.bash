#/bin/bash

if [ "${ELASTICSEARCH_URL}" != "" ]; then
  sed -ri "s,#elasticsearch.url:.*,elasticsearch.url: ${ELASTICSEARCH_URL}," ${PROD_INSTALL}/config/kibana.yml
fi
if [ "${SERVER_HOST}" != "" ]; then
  sed -ri "s,#server.host:.*,server.host: ${SERVER_HOST}," ${PROD_INSTALL}/config/kibana.yml
else
  sed -ri "s,#server.host:.*,server.host: $(getent ahostsv4 $(hostname) | awk '{ print $1 }' | head -n 1)," ${PROD_INSTALL}/config/kibana.yml
fi

${PROD_INSTALL}/bin/kibana ${STARTUP_PARAMS}
