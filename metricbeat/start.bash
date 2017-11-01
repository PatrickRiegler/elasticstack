#!/usr/bin/dumb-init /bin/bash

${PROD_INSTALL}/metricbeat -e -c ${PROD_INSTALL}/${CONF} -d "publish"

