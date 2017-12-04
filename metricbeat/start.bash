#/bin/bash

if [ -z "${CONF}" ]; then
	export CONF="metricbeat.yml"
fi

if [ -z "${STARTUP_PARAMS}" ]; then
	STARTUP_PARAMS="-e -c ${PROD_INSTALL}/${CONF} -d 'publish'"
fi

if [ ! -z "${ELASTICSEARCH_URL}" ]; then
	sed -i "s,localhost:9200,${ELASTICSEARCH_URL}," ${PROD_INSTALL}/${CONF}
fi

${PROD_INSTALL}/metricbeat ${STARTUP_PARAMS}

