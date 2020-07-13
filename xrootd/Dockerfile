FROM centos:7

RUN yum -y install curl.x86_64 bind-utils.x86_64 redhat-lsb.x86_64 bzip2.x86_64 https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&\
rpm --import http://linuxsoft.cern.ch/wlcg/RPM-GPG-KEY-wlcg &&\
yum -y install http://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm alicexrdplugins xrootd xrootd-server xrootd-client xrootd-client-devel xrootd-python

USER xrootd

CMD ["xrootd"]
# bump CI
