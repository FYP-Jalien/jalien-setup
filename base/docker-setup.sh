yum update;

# Install dependencies
yum install -y wget
export LC_ALL=C
yum install -y java-11-openjdk-devel python3 python3-pip git slapd openldap-clients openldap openldap-servers rsync vim tmux less cmake zlib1g-dev uuid uuid-dev libssl-dev 

wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/e/entr-4.4-1.el7.x86_64.rpm
rpm -ivh entr-4.4-1.el7.x86_64.rpm
yum install entr
rm -f entr-4.4-1.el7.x86_64.rpm

systemctl start slapd

# Install XRootD
wget https://xrootd.slac.stanford.edu/download/v4.12.1/xrootd-4.12.1.tar.gz
tar xvzf xrootd-4.12.1.tar.gz
mkdir /build && cd /build
cmake /xrootd-4.12.1 -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_PERL=FALSE
make && make install
cd /


#Install HTCondor
yum update
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y https://research.cs.wisc.edu/htcondor/repo/8.8/el7/release/htcondor-release-8.8-1.el7.noarch.rpm
yum install -y condor supervisor environment-modules tcl

