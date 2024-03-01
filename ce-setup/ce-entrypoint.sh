#!/bin/bash
set -e

alternatives --set java /usr/lib/jvm/java-11-zulu-openjdk-jdk/bin/java

JALIEN_DEV=/jalien-dev
CE_CONFIG=$JALIEN_DEV/config/ComputingElement/docker
LOGS=$JALIEN_DEV/logs
bash start.sh &>$LOGS/htcondor_starter.log &

#setup submituser to submit jobs on HTCondor and start CE
[ ! -e /home/submituser ] && adduser submituser
echo "submituser:toor" | chpasswd
cp $CE_CONFIG/custom-classad.jdl /home/submituser
[ ! -e /home/submituser/tmp ] && su submituser -c "mkdir /home/submituser/tmp /home/submituser/log"
touch /home/submituser/no-proxy-check /home/submituser/enable-sandbox

mkdir -p /home/submituser/.alien/config
echo "custom.jobagent.jar=$JALIEN_DEV/alien-cs.jar" > "/home/submituser/.alien/config/version.properties"
echo "disable.enforce=true" >> "/home/submituser/.alien/config/version.properties"

#run CE with auto reloading
CE_CMD="java -cp $JALIEN_DEV/alien-cs.jar -Duserid=$(id -u) -Dcom.sun.jndi.ldap.connect.pool=false -DAliEnConfig=$CE_CONFIG -Djava.net.preferIPv4Stack=true alien.site.ComputingElement"
#CE_CMD="java -cp $JALIEN_DEV/alien-users.jar -server -XX:+OptimizeStringConcat -XX:CompileThreshold=20000 -Xms64m -Xmx512m  -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+UseCompressedOops -XX:MaxTrivialSize=1K -Duserid=$(id -u) -Dcom.sun.jndi.ldap.connect.pool=false --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED -Djava.io.tmpdir=/tmp -DAliEnConfig=$CE_CONFIG -Djava.net.preferIPv4Stack=true alien.site.ComputingElement"

su submituser -c "$CE_CMD"
