#!/bin/bash
echo "changing permissions..."
echo root | su root -c "chmod -v +777 /jalien-dev/SEshared /shared-volume"
echo root | su root -c "chmod -v 644 /jalien-dev/TkAuthz.Authorization"
ls -l /jalien-dev
xrootd -c /etc/xrootd/xrootd-standalone.cfg