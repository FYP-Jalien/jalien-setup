FROM ubuntu:18.04
COPY testVOEnv.sh docker-setup.sh setuplocalVO.sh verifylocalVO.sh entrypoint.sh ./

ENV JAVA_HOME='/usr/lib/jvm/java-11-oracle'

RUN /bin/bash docker-setup.sh;