#!/bin/bash
set -e

JALIEN_DEV=/jalien-dev
CE_CONFIG=$JALIEN_DEV/config/ComputingElement/docker
LOGS=$JALIEN_DEV/logs
HTCONDOR_CONF=/ce-setup/htcondor-conf

#setup htcondor conf and start it
cp $HTCONDOR_CONF/01* /etc/condor/config.d
cp $HTCONDOR_CONF/start.sh $HTCONDOR_CONF/update-secrets $HTCONDOR_CONF/update-config / 
cp $HTCONDOR_CONF/supervisord.conf /etc/
bash start.sh &>$LOGS/htcondor_starter.log &

#setup submituser to submit jobs on HTCondor and start CE
adduser submituser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "submituser:toor" | chpasswd
su submituser
cp $CE_CONFIG 
mkdir /home/submituser/tmp /home/submituser/log
touch /home/submituser/no-proxy-check /home/submituser/enable-sandbox
cp $JALIEN_DEV/alien-cs.jar /home/submituser/

#run CE with auto reloading
CE_CMD="java -cp /home/submituser/alien-cs.jar -Duserid=$(id -u) -Dcom.sun.jndi.ldap.connect.pool=false -DAliEnConfig=/home/submituser/config -Djava.net.preferIPv4Stack=true alien.site.ComputingElement"
#CE_CMD="java -cp $JALIEN_DEV/alien-users.jar -server -XX:+OptimizeStringConcat -XX:CompileThreshold=20000 -Xms64m -Xmx512m  -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+UseCompressedOops -XX:MaxTrivialSize=1K -Duserid=$(id -u) -Dcom.sun.jndi.ldap.connect.pool=false --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED -Djava.io.tmpdir=/tmp -DAliEnConfig=$CE_CONFIG -Djava.net.preferIPv4Stack=true alien.site.ComputingElement"
ls /home/submituser/*.jar | entr -rcs "$CE_CMD &>~/computing_element_stdout.txt" &
tail --pid $! -f ~/computing_element_stout.txt