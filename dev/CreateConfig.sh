#!/bin/bash
[ x"$1" == x"" ] && echo "Usage: \$1<out> directory where to put testVO/config" && exit 1

out="$(realpath $1)/config"
[ -d $out ] && echo "output directory already exists" && exit 1
mkdir -p "$out"

cat > $out/config.properties << EoF
ldap_server = 127.0.0.1:8389
ldap_root = o=localhost,dc=localdomain
alien.users.basehomedir = /localhost/localdomain/user/

apiService = 127.0.0.1:8998

trusted.certificates.location = $out/trusts
host.cert.priv.location = $out/globus/hostkey.pem
host.cert.pub.location = $out/globus/hostcert.pem
user.cert.priv.location = $out/globus/userkey.pem
user.cert.pub.location = $out/globus/usercert.pem
alice_close_site = JTestSite

jAuthZ.priv.key.location = $out/globus/AuthZ_priv.pem
jAuthZ.pub.key.location = $out/globus/AuthZ_pub.pem
SE.priv.key.location = $out/globus/SE_priv.pem
SE.pub.key.location = $out/globus/SE_pub.pem
EoF

cat > $out/logging.properties << EoF
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
alien.level = INFO
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

write_db_config $out/processses.properties processes
write_db_config $out/alice_data.properties testVO_data
write_db_config $out/alice_users.properties testVO_users
