#!/usr/bin/dumb-init /bin/bash

# network host always needs to be patched - also on PROD
sed -ri "s,network.host:.*,network.host: $(getent ahostsv4 $(hostname) | awk '{ print $1 }' | head -n 1)," ${PROD_INSTALL}/config/elasticsearch.yml
sed -ri "s,#network.host: 192.168.0.1,network.host: $(getent ahostsv4 $(hostname) | awk '{ print $1 }' | head -n 1)," ${PROD_INSTALL}/config/elasticsearch.yml

${PROD_INSTALL}/bin/elasticsearch ${STARTUP_PARAMS}
