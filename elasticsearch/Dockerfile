FROM artifactory.six-group.net/sdbi/six-rhel7:latest

MAINTAINER HAKA6-Pacemakers <HAKA6-Pacemakers@six-group.com>

ENV HOME_DIR=/var/elastic 
ENV INSTALL_DIR=/opt/elastic

ENV PROD=elasticsearch
ENV PROD_INSTALL=${INSTALL_DIR}/${PROD} PROD_HOME=${HOME_DIR}/${PROD}

ARG AUTH

RUN mkdir -p ${PROD_HOME} ${PROD_INSTALL}
RUN chmod -R 755 ${INSTALL_DIR} ${HOME_DIR} \
	&& fix-permissions.sh ${PROD_HOME} \
	&& fix-permissions.sh ${PROD_INSTALL}

RUN yum install -y hostname* \
	&& yum clean all

RUN echo $AUTH

# Install Elasticsearch.
RUN \
   curl -f -o ${INSTALL_DIR}/${ES_PKG_NAME}.${ES_PKG_EXT} -u ${AUTH} https://artifactory.six-group.net/artifactory/commercial-generic-release-local/elastic/${PROD}/${ES_PKG_NAME}.${ES_PKG_EXT} && \
  cd ${INSTALL_DIR} && \
  tar xzf ${ES_PKG_NAME}.${ES_PKG_EXT} && \
  rm -f ${ES_PKG_NAME}.${ES_PKG_EXT} && \
  mv $ES_PKG_NAME ${PROD} && \
  mkdir -p ${PROD_HOME} && \
  chown -R ${RUN_USER}:${RUN_USER} ${PROD_INSTALL} ${PROD_HOME} && \
  chmod -R g+w ${PROD_HOME}

