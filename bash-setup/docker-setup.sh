apt update;
apt-get install -y debconf-utils; 
{ \
echo mysql-community-server mysql-community-server/root-pass password ''; \
echo mysql-community-server mysql-community-server/re-root-pass password ''; \ 
} | debconf-set-selections \
&& apt install -y mysql-server;
apt install -y openjdk-11-jdk;

apt install -y python3;
LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils;
export LDAP_ROOTPASS='toor';
export LDAP_ORGANISATION='cern jalien docker';
export LDAP_DOMAIN='jaliendocker.com';
export JALIEN_HOME='/jalien';
export JALIEN_REPO='https://gitlab.cern.ch/jalien/jalien.git';
export CERTS='/jalien-dev/certs';
export TVO_CERTS='~/.j/testVO/globus';

apt install -y python3-pip;
pip3 install --upgrade pip;
apt install -y git;

git clone --depth=1 $JALIEN_REPO;
apt install -y unzip;

exit 0;