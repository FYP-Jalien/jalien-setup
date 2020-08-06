#!/bin/bash
git clone --depth=1 https://gitlab.cern.ch/jalien/jalien.git /jalien
git clone --depth=1 https://github.com/xrootd/xrootd.git --branch=stable-4.12.x
mkdir /build && cd /build
cmake /xrootd -DCMAKE_INSTALL_PREFIX=/opt/xrootd -DENABLE_PERL=FALSE
make && make install
cp /opt/xrootd/lib/* /lib/
cd /