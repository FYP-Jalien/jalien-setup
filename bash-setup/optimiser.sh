#!/bin/bash
                    
echo "Ceci n'est pas un Optimizer"
MYSQLCALL="mysql --verbose --host=127.0.0.1 --port=3307 --password=pass --user=root -D processes -e"
$MYSQLCALL 'insert into HOSTS (hostId, date, maxJobs, cename, Version, maxqueued, queues, status, hostPort, rating, connected, hostName, siteId, commandName, adminName) values (12277789, NULL, 400, "ALICE::JTestSite:firstce", "v2-19.395", 5, NULL, "CONNECTED", 1094, NULL, 1, "localhost.localdomain", 1, NULL, NULL);'
while :
do
        echo \"Optimizing\"
        #Transition "Inserting" jobs to "Waiting"
        $MYSQLCALL "update QUEUE set statusId=5 where statusId=1;"
        #Add JOBAGENT table entry
        #$MYSQLCALL "insert into JOBAGENT(entryId,priority,noce,fileBroker,revision,price,partition,disk,ttl,oldestQueueId,ce,userId,packages,site,counter)values('1','100','','0','0','1','%','50000000','80000','0',',ALICE::JALIEN::CEJALIEN,','6','%',',JALIEN,',1)" 
        #$MYSQLCALL "insert into JOBAGENT (entryId,priority,noce,fileBroker,revision,price,partition,disk,ttl,oldestQueueId,ce,userId,site,counter) values (1,100,NULL,0,0,1.0,NULL,50000000,80000,0,'LOCALHOST::JTESTSITE::FIRSTSE',6,'JTESTSITE',1);"
        #$MYSQLCALL "insert into JOBAGENT (entryId,priority,noce,fileBroker,revision,price,disk,ttl,oldestQueueId,ce,userId,packages,site,counter) values (1,100,'',0,0,1,0,0,0,'LOCALHOST::JTESTSITE::FIRSTSE',1235890,'%','JTESTSITE',1);"
        $MYSQLCALL 'insert into JOBAGENT (entryId,priority,noce,fileBroker,`partition`,disk,ttl,ce,userId,packages,site,counter,price,oldestQueueId,revision) values (1,100,"",0,",,",0,0,",ALICE::JTestSite::firstce,",1235890,"%",",JTestSite,",1,1,0,0);'
        #Register jobs transitioned to "Waiting" with the JOBAGENT entry
        $MYSQLCALL  "update QUEUE set agentId=1 where statusId=5;"
        #Cleanup killed jobs
        $MYSQLCALL "delete from QUEUE where statusId='-14';"
        sleep 30
done
