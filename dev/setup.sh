#!/bin/bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
git clone --depth=1 https://gitlab.cern.ch/jalien/jalien /jalien
