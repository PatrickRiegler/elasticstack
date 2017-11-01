FROM artifactory.six-group.net/sdbi/six-rhel7:latest

MAINTAINER HAKA6-Pacemakers <HAKA6-Pacemakers@six-group.com>

ENV HOME_DIR=/var/elastic 
ENV INSTALL_DIR=/opt/elastic

ENV PROD=logstash
ENV PROD_INSTALL=${INSTALL_DIR}/${PROD} PROD_HOME=${HOME_DIR}/${PROD}

RUN mkdir -p ${PROD_HOME} ${INSTALL_DIR}
RUN chmod -R 755 ${INSTALL_DIR} ${HOME_DIR} \
	&& fix-permissions.sh ${PROD_HOME} \
	&& fix-permissions.sh ${INSTALL_DIR}

RUN yum install -y hostname* \
	&& yum clean all

RUN echo $ARTIFACTORY_CREDENTIALS

ENV ES_PKG_NAME ${PROD}-5.6.3
ENV ES_PKG_EXT=tar.gz

# Install logstash
RUN \
   curl -f -o ${INSTALL_DIR}/${ES_PKG_NAME}.${ES_PKG_EXT} -u ${ARTIFACTORY_CREDENTIALS} https://artifactory.six-group.net/artifactory/commercial-generic-release-local/elastic/${PROD}/${ES_PKG_NAME}.${ES_PKG_EXT} && \
  cd ${INSTALL_DIR} && \
  tar xzf ${ES_PKG_NAME}.${ES_PKG_EXT} && \
  rm -f ${ES_PKG_NAME}.${ES_PKG_EXT} && \
  mv $ES_PKG_NAME ${PROD} && \
  fix-permissions.sh ${PROD_INSTALL}

COPY logstash/logstash.conf ${PROD_INSTALL}/config/
COPY logstash/start.bash ${PROD_INSTALL}/
RUN fix-permissions.sh ${PROD_INSTALL}/start.bash && \
	fix-permissions.sh ${PROD_INSTALL}/config/logstash.conf && \
	chmod +x ${PROD_INSTALL}/start.bash

ENV PATH=${PATH}:${PROD_INSTALL}

# Define mountable directories.
VOLUME ${PROD_HOME}

# Define working directory.
WORKDIR ${PROD_INSTALL}

# Expose ports.
#EXPOSE 9200 9300

CMD ${PROD_INSTALL}/start.bash


