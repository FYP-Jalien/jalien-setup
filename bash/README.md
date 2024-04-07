# Automated Jalien Replica Setup Scripts

This project provides automated shell scripts to set up a Jalien Replica Docker multi-container setup from scratch. Users only need to customize the configuration file and add their relevant configurations.

## Getting Started

### 1. Setting File Permissions

Before running the setup scripts, ensure that the execution permissions are granted to all relevant shell script files. You can achieve this by running the following command in the project directory:

```bash
chmod +x ./tasks/*.sh
chmod +x ./containers/*.sh
```

Follow these steps to set up the Jalien Replica Docker multi-container setup:

### 2. Configuration

#### 2.1. Create the configuration file `config/config.sh` by copying the content from `config.example`

```bash
cp config.example config/config.sh
```

#### 2.2. Fill in the empty fields in config/config.sh

```bash
#!/bin/bash

# Path to the directory where all bash files are stored
# e.g.  export SCRIPT_DIR=/home/james/Replica/bash 
export SCRIPT_DIR=<path_to_script_directory>

# Path to the directory where the shared volume will be created
# e.g.  export SHARED_VOLUME=/home/james/Replica/SHARED_VOLUME
export SHARED_VOLUME=<shared_volume_path>

# Path to the directory where the Jalien repository will be cloned
# e.g.  export JALIEN=/home/james/Replica/jalien
export JALIEN=<jalien_path>

# Path to the directory where the Jalien-setup repository will be cloned
# e.g.  export JALIEN_SETUP=/home/james/Replica/jalien-setup
export JALIEN_SETUP=<jalien_setup_path>

export JALIEN_SOURCE="https://github.com/FYP-Jalien/jalien"
export JALIEN_SETUP_SOURCE="https://github.com/FYP-Jalien/jalien-setup"

# Name of the Docker containers
# Make sure to change these names if necessary
export CE_NAME=shared_volume_JCentral-dev-CE_1
export JCENTRAL_NAME=shared_volume_JCentral-dev_1
export SCHEDD_NAME=shared_volume_schedd_1
export SE_NAME=shared_volume_JCentral-dev-SE_1
export WORKER_NAME=shared_volume_worker1_1
```

#### 2.3 Make sure that the current user is in the `docker` group

If not please follow this steps to add the user to the docker group  

1. Create the `docker` group

```bash
sudo groupadd docker
```

2. Add the user to the `docker` group

```bash
sudo usermod -aG docker $USER
```

3. Log out and log back or use following command to activate the changes to groups:

```bash
newgrp docker
```

4. Verify that `docker` commands can be run without `sudo`

```bash
docker ps
```

### 3. Running the Setup

#### 3.1. Run the setup using the provided script

```bash
./tasks/start.sh
```

By default, this script will stop and remove all related containers, synchronize with the Jalien JAR, bring up the containers, and start the optimizer.

#### Optional command-line arguments

- --pre: Execute pre-setup tasks.
- --make: Make images locally while executing pre-setup tasks
- --shared: Execute shared volume setup.
- --remove: Remove all docker containers (after down them, only effective when --no-jalien is not used)
- --local-images: Run the setup with locally built images
- --no-pre: Skip pre-setup tasks.
- --no-shared: Skip shared volume setup.
- --no-sync: Skip jar synchronization.
- --no-jalien: Skip Jalien setup.
- --no-opt: Skip optimization.
- --ui: Starts executions in separate terminals with logs visible

Please note that recreating the shared volume will always result in the removal of existing containers.

##### Examples

```bash
# Run the setup starting with creating shared volume in UI mode
./tasks/start.sh --shared --ui

# Run the full setup including pre-setup, shared volume setup, Jalien Replica setup, and optimizer:
./tasks/start.sh --pre

# Run the full setup including pre-setup with locally building images, shared volume setup, Jalien Replica setup, and optimizer:
./tasks/start.sh --pre --make

# Run the pre-setup and shared volume setup:
./tasks/start.sh --pre --no-jalien

# Run the full setup including shared volume setup, Jalien Replica setup, and optimizer:
./tasks/start.sh --shared

# Run the full setup with locally built images:
./tasks/start.sh --shared --local-images

# Run only shared volume setup:
./tasks/start.sh --shared --no-jalien

# Run the Jalien Jalien sync, Replica Setup and Optimiser:
./tasks/start.sh

# Run the Jalien Replica Setup and Optimiser:
./tasks/start.sh --no-sync

# Run Jalien sync:
./tasks/start.sh --no-jalien

# Run Jalien sync and JAlien Replica setup excluding optimization:
./tasks/start.sh --no-opt

```

## Contributing

Feel free to contribute by opening issues or submitting pull requests.

