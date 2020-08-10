#!/bin/bash
git clone --depth=1 https://gitlab.cern.ch/jalien/jalien.git /jalien
apt install -y wget
wget https://xrootd.slac.stanford.edu/download/v4.12.1/xrootd-4.12.1.tar.gz
tar xvzf xrootd-4.12.1.tar.gz
mkdir /build && cd /build
cmake /xrootd-4.12.1 -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_PERL=FALSE
make && make install
cd /
