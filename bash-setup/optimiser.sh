#!/bin/bash
                    
echo "Ceci n'est pas un Optimizer"
MYSQLCALL="mysql --verbose --host=127.0.0.1 --port=3307 --password=pass --user=root -D processes -e"
$MYSQLCALL 'update HOSTS set maxJobs=3000, maxqueued=300 where 1=1;UPDATE SITEQUEUES SET blocked="open";'
$MYSQLCALL 'insert into PRIORITY(userId,maxUnfinishedJobs,maxTotalCpuCost,maxTotalRunningTime) values (1235890, 10000,10000,10000);'
$MYSQLCALL 'insert into SITEQUEUES(siteId,site) values (-1,"unassigned::site");'

#Log all queries
#$MYSQLCALL 'set global general_log = 1;'
#$MYSQLCALL 'set global log_output = "table";'

while :
do
        echo \"Optimizing\"
        #Transition "Inserting" jobs to "Waiting"
        $MYSQLCALL "update QUEUE set statusId=5 where statusId=1;"
        #Add JOBAGENT table entry
        #$MYSQLCALL "insert into JOBAGENT(entryId,priority,noce,fileBroker,revision,price,partition,disk,ttl,oldestQueueId,ce,userId,packages,site,counter)values('1','100','','0','0','1','%','50000000','80000','0',',ALICE::JALIEN::CEJALIEN,','6','%',',JALIEN,',1)" 
        #$MYSQLCALL "insert into JOBAGENT (entryId,priority,noce,fileBroker,revision,price,partition,disk,ttl,oldestQueueId,ce,userId,site,counter) values (1,100,NULL,0,0,1.0,NULL,50000000,80000,0,'LOCALHOST::JTESTSITE::FIRSTSE',6,'JTESTSITE',1);"
        #$MYSQLCALL "insert into JOBAGENT (entryId,priority,noce,fileBroker,revision,price,disk,ttl,oldestQueueId,ce,userId,packages,site,counter) values (1,100,'',0,0,1,0,0,0,'LOCALHOST::JTESTSITE::FIRSTSE',1235890,'%','JTESTSITE',1);"

	$MYSQLCALL 'insert into JOBAGENT (entryId,priority,noce,fileBroker,`partition`,disk,cpucores,ttl,ce,userId,packages,site,counter,price,oldestQueueId,revision) values (1,100,"",0,"%",0,1,0,",ALICE::JTestSite::firstce,",1235890,"%",",JTestSite,",1,1,0,0);'

	# Uncomment this for testing SITECONSTRAINTS
	# $MYSQLCALL 'insert into JOBAGENT (entryId,priority,noce,fileBroker,`partition`,disk,cpucores,ttl,ce,userId,packages,site,counter,price,oldestQueueId,revision,OS_NAME,CPU_flags,CGROUPSv2_AVAILABLE) values (1,100,"",0,",,",0,1,0,",ALICE::JTestSite::firstce,",1235890,"%",",JTestSite,",1,1,0,0,"CentOS Linux","%bc%", TRUE);'
        ##$MYSQLCALL 'insert into JOBAGENT (entryId,priority,noce,fileBroker,`partition`,disk,cpucores,ttl,ce,userId,packages,site,counter,price,oldestQueueId,revision,OS_NAME,CPU_flags,CGROUPSv2_AVAILABLE) values (2,100,"",0,",,",0,1,0,",ALICE::JTestSite::firstce,",1235891,"%",",JTestSite,",1,1,0,0,"CentOS Linux","avx", FALSE);'
        #Register jobs transitioned to "Waiting" with the JOBAGENT entry
        $MYSQLCALL  "update QUEUE set agentId=1 where statusId=5;"
        #Cleanup killed jobs
        $MYSQLCALL "delete from QUEUE where statusId='-14';"
        [ x"$1" = x"-o" ] && exit 0
        sleep 30
done
