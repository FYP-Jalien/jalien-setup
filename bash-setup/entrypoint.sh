#!/bin/bash
set -e

export JALIEN_HOME=/jalien
export JALIEN_SETUP=/jalien-setup
export CERTS=/jalien-dev/certs
export TVO_CERTS=/root/.j/testVO/globus
export JALIEN_DEV=/jalien-dev
export USER_ID=${USER_ID:-1000}

# Get the jar
cd $JALIEN_HOME

chmod +t $JALIEN_DEV
pushd $JALIEN_DEV
    touch setup_log.txt verify_log.txt jcentral_log.txt
    chown $USER_ID *.txt
popd

# Do setup
bash $JALIEN_SETUP/bash-setup/setuplocalVO.sh &>$JALIEN_DEV/setup_log.txt &
tail --pid $! -f $JALIEN_DEV/setup_log.txt

# Verify setup
bash $JALIEN_SETUP/bash-setup/verifylocalVO.sh &>$JALIEN_DEV/verify_log.txt &
tail --pid $! -f  $JALIEN_DEV/verify_log.txt

# Export data that should be shared
cp -r $TVO_CERTS $CERTS

# Fix the permissions
chown -vR $USER_ID $CERTS
chmod -v 777 $CERTS/globus/ $JALIEN_DEV/SEshared $CERTS
chmod -v 644 $CERTS/globus/SE/*.pem $CERTS/globus/authz/*.pem 

# Start JCentral for good
ls $JALIEN_DEV/*.jar | entr -rcs "cp -v $JALIEN_DEV/*.jar $JALIEN_HOME && ./testj central &>$JALIEN_DEV/jcentral_log.txt" &
tail --pid $! -f $JALIEN_DEV/jcentral_log.txt
