# JAliEn in a Box

Hello there!

This repository contains the work done to setup and run a local replica of JAliEn using docker containers. 

The containers in the replica deployment are:
- JCentral (LDAP, MySQL, Certificates) : `JCentral-dev`
- XRootD Storage Element (SE) : `JCentral-dev-SE`
- Computing Element (CE) : `JCentral-dev-CE`
- HTCondor Central Manager: `schedd`
- HTcondor Worker : `worker`

How to setup a local VO
========================

Get JCentral Docker image
-------------------------
- Pull the image: 
  `gitlab-registry.cern.ch/adangwal/jalien/jalien-modified:latest`

- Or build the image manually: 
  `docker build -t gitlab-registry.cern.ch/adangwal/jalien/jalien-modified .`

Run setup
---------
```bash
./test-setup.py create-jcentral (setup of docker container)
./test-setup.py start-jcentral
# jcentral should be running from here
```

## Instructions of use:

##### Dependencies
For host system
- docker
- docker-compose
- java 11.08+
- MySQL
- jalien repository clone and or alien-cs.jar

##### Building containers
Build containers using `make all` in `/path/to/repo` on your local system

##### Setup
- Export `$SHARED_VOLUME` (eg: `export SHARED_VOLUME=/path/doesn't/exist/yet`)
- Run `/path/to/repo/bin/jared --jar /path/to/jalien/jar --volume $SHARED_VOLUME`
- Config, logs and certificates can be found in `$SHARED_VOLUME`, along with `docker-compose.yml` and `env_setup.sh`

##### Deploy containers
- Run `docker-compose up -d` in `$SHARED_VOLUME` directory

##### Using alien.py
To use an interface such as `alien.py`, the steps assume that `alien.py` is installed correctly on host system.  
- Add `JCentral-dev`, `JCentral-dev-SE` to your system's  `/etc/hosts` file (with ip either as `127.0.0.1` or `172.17.0.1`)
- Source the `env_setup.sh` file in `$SHARED_VOLUME`
- Run `alien.py`

##### SE functionalities
- Run `alien.py cp /path/to/file alien://`

```
[xjalienfs] / > alien.py cp /path/to/file-sample alien://
alien.py cpjobID: 1/1 >>> Start
jobID: 1/1 >>> ERRNO/CODE/XRDSTAT 0/0/0 >>> STATUS OK >>> SPEED 2.88 KiB/s MESSAGE: [SUCCESS]

[xjalienfs] / > alien.py
AliEn[jalien]:/localhost/localdomain/user/j/jalien/ >ls
file-sample
```

##### CE functionalities
- Write your jdl file and job script

sample.jdl

```
Executable = "/localhost/localdomain/user/j/jalien/testscript.sh";
Output = {stdout@disk=1};
OutputDir = "/localhost/localdomain/user/j/jalien/output_dir_new/";
```
testscript.sh

```
#!/bin/bash
echo "it works :)"
```

NOTE: Make sure to specify `disk=1` (no trailing white spaces, failure to remove them can result in `ESV`) as current deployment has only 1 SE, failing to do so will result in a `DW` state even after succesfull job execution. 

- Run `alien.py cp /path/to/sample.jdl alien://` and `alien.py cp /path/to/testscript.sh alien://`

```
[xjalienfs] / > alien.py cp /sample.jdl alien://
alien.py cpjobID: 1/1 >>> Start
jobID: 1/1 >>> ERRNO/CODE/XRDSTAT 0/0/0 >>> STATUS OK >>> SPEED 2.88 KiB/s MESSAGE: [SUCCESS] 
[xjalienfs] / > alien.py cp /testscript.sh alien://
alien.pyjobID: 1/1 >>> Start
jobID: 1/1 >>> ERRNO/CODE/XRDSTAT 0/0/0 >>> STATUS OK >>> SPEED 3.84 KiB/s MESSAGE: [SUCCESS] 
```

- Run `bash /path/to/repo/bash-setup/optimiser.sh`
- Run `alien.py submit sample.jdl`

```
Submitting /localhost/localdomain/user/j/jalien/sample.jdl
Your new job ID is 1888757065
```
- Run `alien.py ps` to verify status

```
jalien 1888757065    0    I                 testscript.sh
```

this show status as well (I- Inserted, W- Waiting, ASG- Assigned, SV- Saving, D- Done, DW- Done Waiting)
Any status starting with E is an error.

- Run `alien.py ls` to check if output and/ or directories created

Before job completion

```
AliEn[jalien]:/localhost/localdomain/user/j/jalien/ >ls
sample.jdl
testscript.sh
```
After completion

```
AliEn[jalien]:/localhost/localdomain/user/j/jalien/ >ls
output_dir_new/
sample.jdl
testscript.sh

AliEn[jalien]:/localhost/localdomain/user/j/jalien/ >cd output_dir_new/
AliEn[jalien]:/localhost/localdomain/user/j/jalien/output_dir_new/ >ls
stdout
AliEn[jalien]:/localhost/localdomain/user/j/jalien/output_dir_new/ >cat stdout
it works :)
```
Do note CE is a running process and will keep creating files in the background inside the container. Please make sure to teardown deployment after use. 

## For the Curious

There are many things one can tweak within the replica specifically in the config files, present in `$SHARED_VOLUME/config`.

One can also use the autoreloading feature of the deployment. After any changes made, either `touch $SHARED_VOLUME/alien-cs.jar` or replace jar with a new `alien-cs.jar` to restart JCentral and CE within their containers.

# Quick start for xrootd container:

#### Prerequisites:
The jalien-replica.py script must be run successfully (with JCentral-replica running in the background) before manually starting the xrootd container via the below mentioned commands.

First make sure to be in the xrootd directory of the repository
- Run `docker build -t <image-name> .`
- Run `docker run -p 1094:1094 -v <path>/<to>/<shared volume>/<with jcentral replica>:/jalien-dev -it <image-name> /bin/bash`.

Note currently this uses default directory `/tmp` and storage is not persistent.

To run without usage of envelope verification change:
`CMD xrootd -c /etc/xrootd/xrootd-standalone.cfg` to `CMD xrootd` in `Dockerfile` before building image.

#### Test commands:
With alien.py setup (via sourcing env_setup.sh from your shared volume with JCentral-replica) run the following:

```
[root@51aaba2b3155 /]# alien.py cp <file name> alien://
jobID: 1/1 >>> Start
jobID: 1/1 >>> ERRNO/CODE/XRDSTAT 0/0/0 >>> STATUS OK >>> SPEED 8.17 KiB/s MESSAGE: [SUCCESS] 
```
File can also be seen via the interative shell:

```
[root@51aaba2b3155 /]# alien.py
Welcome to the ALICE GRID
support mail: adrian.sevcenco@cern.ch

AliEn[jalien]:/localhost/localdomain/user/j/jalien/ >ls
env_setup.sh
```

# TODO

## Technical Improvements
  - [ ] Host to replica networking, hostnames and DNS
  - [ ] Dedicated shared CVMFS mountpoint without autofs
  - [ ] Improve the file catalog schema (simplify the L tables)
  - [ ] Improve job submission / CE stability
  - [ ] Improve development workflow (start JobAgent from local jar)

## New Features
  - [ ] VO administration, user management
  - [ ] Add LDAP admin web frontend
  - [ ] Register more SEs to test TPC and replica failovers
  - [ ] Register more sites
  - [ ] JobOptimizer and splitting
  - [ ] CVMFS agnostic setup
  - [ ] Monitoring infrastructure - MonALISA

