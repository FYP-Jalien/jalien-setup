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
touch /home/submituser/no-proxy-check /home/submituser/enable-sandbox

#run CE with auto reloading
CE_cmd="java -cp $JALIEN_DEV/alien-users.jar -Duserid=$(id -u) -Dcom.sun.jndi.ldap.connect.pool=false -DAliEnConfig=${CE_CONFIG} -Djava.net.preferIPv4Stack=true alien.site.ComputingElement"
ls $JALIEN_DEV/*.jar | entr -rcs "$CE_CMD &>$LOGS/computing_element_stdout.txt" &
tail --pid $! -f $LOGS/computing_element_stout.txt