FROM gitlab-registry.cern.ch/jalien/dockervobox/voboximg:el9

RUN rm -f /etc/condor/config.d/00-minicondor.vobox \
    && rm -f /etc/condor/config.d/02_container_extra.config \
    && rm -f /etc/condor/config.d/99-alice-vobox.conf \
    && rm -f /home/alicesgm/ce-usage.sh

ENV HTCONDOR_CONF=htcondor-conf
COPY $HTCONDOR_CONF/01* /etc/condor/config.d
COPY $HTCONDOR_CONF/start.sh $HTCONDOR_CONF/update-secrets $HTCONDOR_CONF/update-config / 
COPY $HTCONDOR_CONF/supervisord.conf /etc/

COPY docker-setup.sh /
RUN /bin/bash docker-setup.sh;
ENV JAVA_HOME=='/usr/lib/jvm/java-11-zulu-openjdk-jdk/bin/java'

