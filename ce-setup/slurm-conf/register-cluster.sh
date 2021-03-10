#!/bin/bash

docker exec slurmctld bash -c "/usr/bin/sacctmgr --immediate add cluster name=linux;echo y| /usr/bin/sacctmgr add user submituser Account=root"
docker-compose restart slurmdbd slurmctld
