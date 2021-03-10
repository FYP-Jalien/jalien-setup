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

apt-get install -y software-properties-common

apt install -y wget bzip2 perl gcc git gnupg make munge libmunge-dev libpython-dev libpython3-dev python3-pip libmariadb-dev psmisc bash-completion vim libssl-dev libmysqlclient-dev environment-modules tcl

# Install XRootD
apt install -y wget
wget https://xrootd.slac.stanford.edu/download/v4.12.1/xrootd-4.12.1.tar.gz
tar xvzf xrootd-4.12.1.tar.gz
mkdir /build && cd /build
cmake /xrootd-4.12.1 -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_PERL=FALSE
make && make install
cd /

set -x \
    && git clone https://github.com/SchedMD/slurm.git \
    && cd slurm \
    && git checkout tags/slurm-19-05-1-2 \
    && ./configure --enable-debug --prefix=/usr --sysconfdir=/etc/slurm --with-mysql_config=/usr/bin --libdir=/usr/lib64 \
    &&  make install \
    &&  install -D -m644 etc/cgroup.conf.example /etc/slurm/cgroup.conf.example \
    &&  install -D -m644 etc/slurm.conf.example /etc/slurm/slurm.conf.example \
    &&  install -D -m644 etc/slurmdbd.conf.example /etc/slurm/slurmdbd.conf.example \
    &&  install -D -m644 contribs/slurm_completion_help/slurm_completion.sh /etc/profile.d/slurm_completion.sh
groupadd -r --gid=995 slurm
useradd -r -g slurm --uid=995 slurm
mkdir /var/spool/slurmd /var/run/slurmd /var/run/slurmdbd /var/lib/slurmd /var/log/slurm /data
touch /var/lib/slurmd/node_state \
        /var/lib/slurmd/front_end_state \
        /var/lib/slurmd/job_state \
        /var/lib/slurmd/resv_state \
        /var/lib/slurmd/trigger_state \
        /var/lib/slurmd/assoc_mgr_state \
        /var/lib/slurmd/assoc_usage \
        /var/lib/slurmd/qos_usage \
        /var/lib/slurmd/fed_mgr_state \
    && chown -R slurm:slurm /var/*/slurm* \
    && /usr/sbin/create-munge-key \
    && chown -R munge:munge /etc/munge

groupadd submituser
useradd -m -g submituser submituser
