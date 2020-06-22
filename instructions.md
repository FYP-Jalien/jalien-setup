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
