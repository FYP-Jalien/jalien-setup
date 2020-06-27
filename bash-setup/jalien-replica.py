#!/usr/bin/env python3
import click
import docker
import os
import sys
import subprocess
import socket    
import signal
import shutil

def timeout(signum, frame):
   print("Setup Script taking too long. Check docker logs for more information", file=sys.stderr, flush=True)
   sys.exit(1)

def jalien_cleanup(replica_name, certpath):
    client = docker.from_env()
    click.echo("Cleaning up!")
    click.echo("Deleting old certificates from"+certpath)
    try:
        shutil.rmtree(certpath)
    except:
        pass
    click.echo("Removing old JCentral container (if any)")
    try:
        jalien_container = client.containers.list(filters={'name':replica_name})[0]
        print("A container with the name ",replica_name," already exists. Please remove or specify a different name", 
              file=sys.stderr, flush=True)
        sys.exit(1)
    except:
        print("Container named ", replica_name," does not exist!", file=sys.stderr, flush=True)
    click.echo("Finished cleanup!")

def get_info(path):
    certpath = path+"/certs"
    print("Making directory "+certpath+" for certificates... \n" +
    "Please make sure "+certpath+"/globus is added to $X509_CERT_DIR \n" +
    "Please make sure "+certpath+"/globus/usercert.pem is added to $X509_USER_CERT, $X509_TOKEN_CERT \n" +
    "Please make sure "+certpath+"/globus/userkey.pem is added to $X509_USER_KEY, $X509_TOKEN_KEY \n"+
    "Alternatively can use . "+path+"/env_source.sh && alienpy\n" +
    "Please make sure to set ALIENPY_JCENTRAL to 127.0.0.1 \n")
    lines = ['certpath='+certpath+'\n','export ALIENPY_JCENTRAL="127.0.0.1"\n', 'export X509_CERT_DIR="${certpath}/globus"\n',
            'export X509_USER_CERT="${X509_CERT_DIR}/usercert.pem"\n', 'export X509_USER_KEY="${X509_CERT_DIR}/userkey.pem"\n' 
            'export JALIEN_TOKEN_CERT="${X509_CERT_DIR}/usercert.pem"\n','export JALIEN_TOKEN_KEY="${X509_CERT_DIR}/userkey.pem"\n']
    with open(path+'/env_setup.sh',"w+") as file:
        file.writelines(lines)

@click.group()
def jalien_docker():
    pass

@jalien_docker.command()
@click.option('--replica-name', 
              default="JCentral-dev", help='Searches for the container with the name.', 
              show_default="Uses JCentral-dev")
@click.argument('certpath')
def cleanup(replica_name, certpath):
    """ Cleans up certificates and looks for running containers """
    jalien_cleanup(replica_name, certpath)

@jalien_docker.command()
@click.option('--path', prompt="Enter absolute path of local JAliEn jar", required=True,
              default=lambda: os.getenv("JALIEN_DEVPATH"), help='The path mounted to docker. Is used to build JCentral.', 
              show_default="Takes path from $JALIEN_DEVPATH")
@click.option('--replica-name', 
              default="JCentral-dev", help='Searches for the container with the name.', 
              show_default="Uses JCentral-dev")
@click.option('--jar', help='The path to jar files. Is used to build JCentral.', show_default="Uses --path")
@click.option('--custom-jalienpath', help='The path to jar files. Is used to build JCentral.', default="$HOME", 
                show_default="Uses container's $HOME")
def run_JCentral(path, replica_name, jar, custom_jalienpath):
    """Creates and runs JCentral replica inside Docker"""
    #setup cleanup 
    path = os.path.abspath(os.path.expanduser(os.path.expandvars(path)))
    if not os.path.isdir(path):
        #Checks if variables are set before running docker container
        print("Directory not found. Cannot mount volume to container or use .jar files", file=sys.stderr, flush = True)
        sys.exit(1)
    
    if jar is None:
        jar = path
    else:
        jar = os.path.abspath(os.path.expanduser(os.path.expandvars(jar)))
        if not os.path.isdir(jar):
            #Checks if variables are set before running docker container
            print("Directory not found. Cannot mount volume to container or use .jar files", file=sys.stderr, flush = True)
            sys.exit(1)
        
        for file in os.listdir(jar):
            if file.endswith(".jar"):
                shutils.copy(file, path)    
    
    certpath=path+"/certs"


    if not any(file.endswith(".jar") for file in os.listdir(path)):
        print("No .jar found", file=sys.stderr, flush = True)
        sys.exit(1)

    #makes tmp directory for sharing certificates between docker and alien.py
    get_info(path)
    uid = os.getuid()

    if os.path.isdir(certpath):
        jalien_cleanup(replica_name, certpath)

    os.mkdir(certpath)
    env = ["JALIEN_HOME=/jalien", 'custom_jalienpath='+custom_jalienpath,"CERTS=/jalien-dev/certs", "TVO_CERTS="+custom_jalienpath+"/.j/testVO/globus", "JALIEN_DEV=/jalien-dev", "USER_ID="+str(uid)]
    #runs docker container
    client = docker.from_env()
    jalien_container = client.containers.run('gitlab-registry.cern.ch/adangwal/jalien/jalien-modified:version0.5', 
                           '/bin/bash entrypoint.sh', auto_remove=True, name=replica_name, environment=env, detach=True,
                           ports={'8998/tcp':'8998', '8097/tcp':'8097'}, volumes={path:{'bind':'/jalien-dev', 'mode':'rw'}})

    if jalien_container.status != 'created':
        print("Something went wrong with container. Streaming logs..", file=sys.stderr, flush = True)
        print(jalien_container.logs())
    
    #setting up timeout if script gets stuck inside container
    signal.signal(signal.SIGALRM, timeout)
    signal.alarm(60) #normally never takes longer than 20 seconds
    for i in jalien_container.logs(stream=True):
        if 'JCentral listening on' in i.decode():
            print("Container is running JCentral")
            break
    sys.exit(0)

@jalien_docker.command()
@click.option('--replica-name', 
              default="JCentral-dev", help='Searches for the container with the name.', 
              show_default="Uses JCentral-dev")
def stop_replica(replica_name):
    """ Stops JCentral replica container """
    client = docker.from_env()
    try:
        jalien_container = client.containers.list(filters={'name':replica_name})[0]
        jalien_container.stop()
    except:
        print("Something went wrong. Please check if container named ", replica_name," exists and is running", 
              file=sys.stderr, flush=True)


if __name__ == '__main__':
    jalien_docker()