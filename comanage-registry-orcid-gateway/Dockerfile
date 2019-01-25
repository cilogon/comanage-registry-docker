FROM debian:stretch

ARG SATOSA_DIR=/opt/satosa
ENV SATOSA_DIR ${SATOSA_DIR}
LABEL satosa_dir=${SATOSA_DIR}

ARG SATOSA_USER=satosa
ENV SATOSA_USER ${SATOSA_USER}
LABEL satosa_user=${SATOSA_USER}

ARG SATOSA_GROUP=satosa
ENV SATOSA_GROUP ${SATOSA_GROUP}
LABEL satosa_group=${SATOSA_GROUP}

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        virtualenv \
        xmlsec1

RUN useradd --home-dir ${SATOSA_DIR} --no-create-home --system ${SATOSA_USER} \
    && mkdir -p ${SATOSA_DIR}/plugins \
    && mkdir -p ${SATOSA_DIR}/attributemaps \
    && chown -R ${SATOSA_USER}:${SATOSA_GROUP} ${SATOSA_DIR}

ARG SATOSA_SRC_URL=git+https://github.com/IdentityPython/SATOSA.git@2de1c81d64eb5831f65e7f0758dbd83a38b7f78d
ENV SATOSA_SRC_URL ${SATOSA_SRC_URL}
LABEL satosa_src_url=${SATOSA_SRC_URL}

WORKDIR ${SATOSA_DIR}

USER ${SATOSA_USER}

RUN /usr/bin/virtualenv -p python3 ${SATOSA_DIR} --no-site-packages \
    && ${SATOSA_DIR}/bin/pip install ${SATOSA_SRC_URL}

USER root

RUN apt-get purge -y git \
    && apt-get clean

USER ${SATOSA_USER}

COPY start.sh ${SATOSA_DIR}/
COPY proxy_conf.yaml ${SATOSA_DIR}/
COPY internal_attributes.yaml ${SATOSA_DIR}/
COPY attributemaps ${SATOSA_DIR}/attributemaps
COPY plugins ${SATOSA_DIR}/plugins

ENTRYPOINT ["/bin/bash", "-c", "${SATOSA_DIR}/start.sh"]
