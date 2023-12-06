ARG BASE_IMAGE=gitlab-registry.cern.ch/linuxsupport/cc7-base
FROM ${BASE_IMAGE}
ARG BASE_IMAGE
ARG VERSION=latest
ARG SERIES=10.0
ARG PACKAGE_LIST

LABEL org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.title="HTCondor Execute Image derived from ${BASE_IMAGE}" \
      org.opencontainers.image.vendor="HTCondor"

LABEL \
    build-date="" \
    io.buildah.version="" \
    license="" \
    name="" \
    org.label-schema.build-date="" \
    org.label-schema.license="" \
    org.label-schema.name="" \
    org.label-schema.schema-version="" \
    org.label-schema.vendor="" \
    org.opencontainers.image.created="" \
    vendor=""

COPY container-install-htcondor.sh /root/container-install-htcondor.sh
RUN \
  export HTCONDOR_VERSION=${VERSION} HTCONDOR_SERIES=${SERIES}; \
  bash -x /root/container-install-htcondor.sh

COPY htcondor-conf/*.conf /etc/condor/config.d/
COPY supervisord.conf /etc/supervisord.conf
RUN mkdir -p /root/config
COPY update-config /
COPY update-secrets /
COPY docker-setup.sh /
RUN chmod +x \
  /update-config \
  /update-secrets \
  /docker-setup.sh

# Create pslots slot users slot1_1 through slot1_64
RUN \
   for n in `seq 1 64`; do \
       useradd slot1_${n} || exit $?; \
   done

COPY $PACKAGE_LIST /root/extra-packagelist.txt
COPY container-install-execute.sh /root/container-install-execute.sh
RUN bash -x /root/container-install-execute.sh /root/extra-packagelist.txt

RUN /bin/bash docker-setup.sh

