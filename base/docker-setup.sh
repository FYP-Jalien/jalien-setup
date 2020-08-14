# Fix systemd-resolved problem
apt update;

# setup MySQL
apt-get install -y debconf-utils;
{ \
echo mysql-community-server mysql-community-server/root-pass password ''; \
echo mysql-community-server mysql-community-server/re-root-pass password ''; \
} | debconf-set-selections \
&& apt install -y mysql-server

# Install dependencies
export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C
apt install -y openjdk-11-jdk python3 python3-pip git slapd ldap-utils rsync vim tmux entr less cmake zlib1g-dev uuid uuid-dev libssl-dev

# Install XRootD
apt install -y wget
wget https://xrootd.slac.stanford.edu/download/v4.12.1/xrootd-4.12.1.tar.gz
tar xvzf xrootd-4.12.1.tar.gz
mkdir /build && cd /build
cmake /xrootd-4.12.1 -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_PERL=FALSE
make && make install
cd /
