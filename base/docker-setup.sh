# Fix systemd-resolved problem
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
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
apt install -y openjdk-11-jdk python3 python3-pip git slapd ldap-utils
