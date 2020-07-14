FROM alisw/slc7-builder
COPY installer.sh /
RUN /bin/bash installer.sh
ADD xrootd-conf /etc/xrootd
USER xrootd

RUN /bin/bash xrootd -c /etc/xrootd/xrootd-standalone.cfg
# bump CI
