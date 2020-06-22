#!/usr/bin/env python3
"""
A command line utility to manage JCentral replicas.
"""

from pathlib import Path
import logging
import os
import shutil
import signal
import sys

import click
import docker

logging.basicConfig(format="%(asctime)s [%(levelname)s] :: %(message)s",
                    datefmt="%Y/%m/%d %H:%M:%S",
                    level=logging.INFO)

DEFAULT_DOCKER_IMAGE = 'gitlab-registry.cern.ch/adangwal/jalien/jalien-modified:version0.4'

# pylint: disable=unused-argument
def timeout(signum, frame):
    """
    Timeout handler in case the setup takes too long.
    """
    logging.error("Setup Script taking too long. Check docker logs for more information")
    sys.exit(1)

def workspace_cleanup(certpath):
    """
    Remove certificates if they already exist in the shared volume.
    """
    logging.info("Deleting old certificates from %s", certpath)
    shutil.rmtree(certpath, ignore_errors=True)
    certpath.mkdir(parents=True, exist_ok=True)
    logging.info("Finished cleanup!")

def params_check(volume, jar):
    """
    Validate command-line parameters (shared volume, jar file)
    """
    if not volume.exists():
        logging.info("Creating the shared volume directory in %s", volume)
        volume.mkdir(parents=True)
    elif volume.is_file():
        logging.error("Shared volume path is a file, not a directory")
        return False

    if jar.is_file():
        shutil.copy(jar, volume)
    else:
        logging.error("JAR file not found in {jar}")
        return False

    return True

def get_info(volume):
    """
    Generate the source_env.sh script contents.
    """
    certpath = str(volume.joinpath("certs"))
    script = ['# Source this script to point JAliEn clients to the replica',
              f'certpath="{certpath}"',
              'export ALIENPY_JCENTRAL="127.0.0.1"',
              'export X509_CERT_DIR="${certpath}/globus"',
              'export X509_USER_CERT="${X509_CERT_DIR}/usercert.pem"',
              'export X509_USER_KEY="${X509_CERT_DIR}/userkey.pem"',
              'export JALIEN_TOKEN_CERT="${X509_CERT_DIR}/usercert.pem"',
              'export JALIEN_TOKEN_KEY="${X509_CERT_DIR}/userkey.pem"']

    return '\n'.join(script)

def bootstrap_workspace(volume, jar, cleanup):
    """
    Prepare the shared volume for starting up a new JCentral instance.
    """
    certpath = volume.joinpath("certs")

    if not params_check(volume, jar):
        logging.error("Can't start the container, exiting...")
        return 1

    if cleanup:
        workspace_cleanup(certpath)

    script = get_info(volume)
    print(script)

    with open(volume.joinpath('env_setup.sh'), "w+") as file:
        file.write(script)

    return 0

def start_container(volume, image, replica_name, cmd):
    """
    Start a JCentral replica container
    """
    uid = os.getuid()
    env = ["USER_ID="+str(uid)]

    client = docker.from_env()
    logging.info("Removing old JCentral container (if any)")
    try:
        jalien_container = client.containers.list(filters={'name':replica_name})[0]
        logging.info("A container with the name %s already exists.", replica_name)
        logging.info("Please remove it or specify a different name.")
        sys.exit(1)
    except IndexError:
        logging.info("Container named %s does not exist!", replica_name)

    logging.info("command is: %s", cmd)
    jalien_container = client.containers.run(image, cmd,
                                             auto_remove=True,
                                             name=replica_name,
                                             environment=env,
                                             detach=True,
                                             ports={'8998/tcp':'8998', '8097/tcp':'8097'},
                                             volumes={
                                                 str(volume):{'bind':'/jalien-dev', 'mode':'rw'},
                                             })

    if jalien_container.status != 'created':
        logging.info("Something went wrong with container. Streaming logs..")
        logging.info(jalien_container.logs())

    return jalien_container

def wait_for_service(jalien_container):
    """
    Parse the container logs until JCentral is up and running.
    """
    signal.signal(signal.SIGALRM, timeout)
    signal.alarm(60) #normally never takes longer than 20 seconds

    for i in jalien_container.logs(stream=True):
        print(i.decode().strip('\n'))

        if 'JCentral listening on' in i.decode():
            print("Container is running JCentral")
            break

@click.group()
# pylint: disable=missing-docstring
def jalien_docker():
    pass

@jalien_docker.command()
@click.option('--volume', default="/tmp/jalien-replica", required=True,
              help='The path mounted to docker. Is used to build JCentral.')
@click.option('--replica-name', default="JCentral-dev",
              help='Searches for the container with the name.')
@click.option('--jar', default="../alien.jar", required=True,
              help='The path to jar files. Is used to build JCentral')
@click.option('--image', default=DEFAULT_DOCKER_IMAGE,
              help="Name of Docker image to be used for the container")
@click.option('--cleanup/--no-cleanup', default=True)
# pylint: disable=too-many-arguments
def start(volume, replica_name, jar, image, cleanup):
    """Creates and runs JCentral replica inside Docker"""
    volume = Path(volume).expanduser().absolute()
    jar = Path(jar).expanduser().absolute()

    try:
        bootstrap_workspace(volume, jar, cleanup)
        jalien_container = start_container(volume, image, replica_name, "/entrypoint.sh")
        wait_for_service(jalien_container)
    # pylint: disable=bare-except,broad-except,invalid-name
    except Exception as e:
        logging.error("Something went wrong, unable to start the service...")
        logging.exception(e)

@jalien_docker.command()
@click.option('--volume', default="/tmp/jalien-replica", required=True,
              help='The path mounted to docker. Is used to build JCentral.')
@click.option('--replica-name', default="JCentral-dev",
              help='Searches for the container with the name.')
@click.option('--jar', default="../alien.jar", required=True,
              help='The path to jar files. Is used to build JCentral')
@click.option('--image', default=DEFAULT_DOCKER_IMAGE,
              help="Name of Docker image to be used for the container")
@click.option('--cleanup/--no-cleanup', default=True)
# pylint: disable=too-many-arguments
def shell(volume, replica_name, jar, image, cleanup):
    """
    Start container and open the shell without running setup.
    """
    volume = Path(volume).expanduser().absolute()
    jar = Path(jar).expanduser().absolute()

    try:
        bootstrap_workspace(volume, jar, cleanup)
        start_container(volume, image, replica_name, "/bin/bash")
        print(f"Now run: docker attach {replica_name}")
    # pylint: disable=bare-except
    except:
        logging.error("Something went wrong, unable to start container")

@jalien_docker.command()
@click.option('--replica-name',
              default="JCentral-dev", help='Searches for the container with the name.',
              show_default="Uses JCentral-dev")
def stop(replica_name):
    """ Stops JCentral replica container """
    client = docker.from_env()
    try:
        jalien_container = client.containers.list(filters={'name':replica_name})[0]
        jalien_container.stop()
    except IndexError:
        logging.warning("Something went wrong." \
                        "Please check if container %s is running", replica_name)

if __name__ == '__main__':
    jalien_docker()
