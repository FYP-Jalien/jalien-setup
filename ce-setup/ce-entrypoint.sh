#!/bin/bash
set -e

JALIEN_DEV=/jalien-dev
CE_CONFIG=$JALIEN_DEV/config/ComputingElement/docker
HOST_CONFIG=$JALIEN_DEV/config/ComputingElement/host
LOGS=$JALIEN_DEV/logs
SLURM_CONF=/ce-setup/slurm-conf

#setup submituser to submit jobs on HTCondor and start CE
[ ! -e /home/submituser ] && adduser submituser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
[ ! -e /data/jobs ] && mkdir /data/jobs /data/logs /data/tmp && chown submituser:submituser -R /data/
echo "submituser:toor" | chpasswd

service munge start

cp $HOST_CONFIG/slurm-environment-$1.config /home/submituser/slurm-environment.config
export SUBMIT_ARGS="--export-file=/home/submituser/slurm-environment.config"
[ ! -e /home/submituser/tmp ] && su submituser -c "mkdir -p /home/submituser/tmp /home/submituser/logs"

#run CE with auto reloading
CE_CMD="java -cp $JALIEN_DEV/alien-cs.jar -Duserid=$(id -u) -Dcom.sun.jndi.ldap.connect.pool=false -DAliEnConfig=$CE_CONFIG -Djava.net.preferIPv4Stack=true alien.site.ComputingElement"
#CE_CMD="java -cp $JALIEN_DEV/alien-users.jar -server -XX:+OptimizeStringConcat -XX:CompileThreshold=20000 -Xms64m -Xmx512m  -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+UseCompressedOops -XX:MaxTrivialSize=1K -Duserid=$(id -u) -Dcom.sun.jndi.ldap.connect.pool=false --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED -Djava.io.tmpdir=/tmp -DAliEnConfig=$CE_CONFIG -Djava.net.preferIPv4Stack=true alien.site.ComputingElement"

#wait for JCentral-dev
while ! /cvmfs/alice.cern.ch/bin/alienv setenv xjalienfs -c ". ${JALIEN_DEV}/env_setup.sh && alien.py pwd"; do sleep 1; done

ls $JALIEN_DEV/*.jar | entr -rcs "su submituser -c \"$CE_CMD\""
