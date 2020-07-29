#!/bin/bash
[ x"$1" == x"" ] && echo "Usage: \$1<out> directory where to put testVO/config" && exit 1

out="$(realpath $1)"
[ -d $out/config ] && echo "config directory already exists" && exit 1
config=$out/config
mkdir -p $config

cat > $config/config.properties << EoF
ldap_server = 127.0.0.1:8389
ldap_root = o=localhost,dc=localdomain
alien.users.basehomedir = /localhost/localdomain/user/

apiService = 127.0.0.1:8098

trusted.certificates.location = $out/trusts
host.cert.priv.location = $out/globus/host/hostkey.pem
host.cert.pub.location = $out/globus/host/hostcert.pem
user.cert.priv.location = $out/globus/user/userkey.pem
user.cert.pub.location = $out/globus/user/usercert.pem
alice_close_site = JTestSite

jAuthZ.priv.key.location = $out/globus/authz/AuthZ_priv.pem
jAuthZ.pub.key.location = $out/globus/authz/AuthZ_pub.pem
SE.priv.key.location = $out/globus/SE/SE_priv.pem
SE.pub.key.location = $out/globus/SE/SE_pub.pem
EoF

cat > $config/logging.properties << EoF
handlers= java.util.logging.FileHandler
java.util.logging.FileHandler.formatter = java.util.logging.SimpleFormatter
java.util.logging.FileHandler.limit = 1000000
java.util.logging.FileHandler.count = 4
java.util.logging.FileHandler.append = true
java.util.logging.FileHandler.pattern = /tmp/alien%g.log
.level = WARNING
lia.level = WARNING
lazyj.level = WARNING
apmon.level = WARNING
alien.level = FINEST
# tell LazyJ to use the same logging facilities
use_java_logger=true
EoF

function write_db_config() {
  filename=$1
  db_name=$2

  cat > $filename <<EoF
password=pass
driver=com.mysql.jdbc.Driver
host=127.0.0.1
port=3307
database=$2
user=root
useSSL=false
EoF
}

write_db_config $config/processses.properties processes
write_db_config $config/alice_data.properties alice_data
write_db_config $config/alice_users.properties alice_users

echo "password=pass" >> $config/ldap.config

# create other dirs
mkdir -p $out/{config,bin,logs,slapd,sql,SE_storage} # but don't create globus and trusts
echo "CreateConfig done"
