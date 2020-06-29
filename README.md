Hello there!

### Instructions on running the bash-conversion setup.

1. Firt as it is meant to work with the bash scripts, change `JALIEN_REPO` to `https://gitlab.cern.ch/adangwal/jalien.git`
and clone the `bash-conversion` branch by changing `git clone --depth=1 $JALIEN_REPO;` to `git clone --depth=1 $JALIEN_REPO bash-conversion` in the `docker-setup.sh` script.

2. Second, compile this repository locally as well and feed the path to the local `alien.jar` appropriately to `jalien-replica.py`

##### This is required for it to work with `jalien-replica.py`.

#### Manual Setup

Alternatively, one can ssh into docker container and run the above manually, including running `./entry-point.sh` with the following environment variables set: 
- `export JALIEN_HOME=/jalien`
- `export custom_jalienpath=/custom/path` (defaults to `$HOME`)

(this is enough to test the working of `./setuplocalVO.sh` and `./verifylocalVO.sh` manually. The rest can be followed for the full experience of connecting to the replica external from docker)

- `export JALIEN_DEV=/jalien-dev` (move alien.jar here manually)
- `export USER_ID=1000`
- `export TVO_CERTS="${custom_jalienpath}/.j/testVO/globus"` (make sure to use `$HOME` if `$custom_jalienpath` not specified)
- `export CERTS="${JALIEN_DEV}/certs"`

command to run 
`docker run --name JCentral-dev -v /path/to/local/jar:/jalien-dev -p 8097:8097 -p 8998:8998 -it gitlab-registry.cern.ch/adangwal/jalien/jalien-modified:version0.5 /bin/bash entrypoint.sh`

#### Automated Setup

command to build docker image:
`docker build -t gitlab-registry.cern.ch/adangwal/jalien/jalien-modified:version0.5 .`

command to run local replica:
`./test-setup.py run-jcentral --path /path/to/local/JAliEn/jar` (final message should be `Container is running JCentral` )


- JCentral service starts based off the provided `.jar`
- Database is populated with default users `jalien` and `admin`
- Certificates generated and exported to shared volume (local .jar path)

(For manual setup need to fill in certpath appropriately)

Run `. /path/to/env_setup.sh && alien.py`

Hopefully everything is fixed/ fixes itself from there :)