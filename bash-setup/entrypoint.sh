#!/bin/bash
set -e

export JALIEN_HOME=/jalien
export JALIEN_SETUP=/jalien-setup
export JALIEN_DEV=/jalien-dev
export LOGS=$JALIEN_DEV/logs
export PATH=$PATH:$JALIEN_SETUP/bash-setup

cd $JALIEN_HOME
ln -vnsf -t $JALIEN_HOME $JALIEN_DEV/*.jar

setuplocalVO.sh &>$LOGS/setup_log.txt &
tail --pid $! -f $LOGS/setup_log.txt

# TODO: enable setup verify again
# Verify setup
# bash $JALIEN_SETUP/bash-setup/verifylocalVO.sh &>$JALIEN_DEV/verify_log.txt &
# tail --pid $! -f  $JALIEN_DEV/verify_log.txt

export CLASSPATH="$(ls lib/*.jar | paste -s | tr '\t' ':'):alien.jar"
JCENTRAL_CMD="java -Duserid=$(id -u) -DAliEnConfig=/jalien-dev/config/JCentral alien.JCentral $(pwd)"

echo "hello world" > $LOGS/jcentral_stdout.txt
ls $JALIEN_DEV/*.jar | entr -rcs "$JCENTRAL_CMD &>$LOGS/jcentral_stdout.txt" &
tail --pid $! -f $LOGS/jcentral_stdout.txt
