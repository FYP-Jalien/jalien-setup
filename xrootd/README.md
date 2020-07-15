### Quick start for xrootd container:

First make sure to be in the xrootd directory of the repository
- Run `docker build -t <image-name> .`
- Run `docker run -p 1094:1094 -it <image-name> /bin/bash`

Note currently this uses default directory `/tmp` and storage is not persistent

To run without usage of envelopes change:
`CMD xrootd -c /etc/xrootd/xrootd-standalone.cfg` to `CMD xrootd` in `Dockerfile` before building image