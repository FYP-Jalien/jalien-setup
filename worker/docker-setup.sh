yum update -y

echo "Installing dependencies"
yum install -y attr alicexrdplugins autoconf automake avahi-compat-libdns_sd-devel bc bind-export-libs bind-libs bind-libs-lite bind-utils binutils bison bzip2-devel cmake compat-libgfortran-41 compat-libstdc++-33 e2fsprogs e2fsprogs-libs environment-modules fftw-devel file-devel flex gcc gcc-c++ gcc-gfortran git glew-devel glibc-devel glibc-static gmp-devel graphviz-devel libcurl-devel libpng-devel libtool libX11-devel libXext-devel libXft-devel libxml2-devel libxml2-static libXmu libXpm-devel libyaml-devel mesa-libGL-devel mesa-libGLU-devel motif-devel mpfr-devel mysql-devel ncurses-devel openldap-devel openssl-devel openssl-static openssh-clients openssh-server pciutils-devel pcre-devel perl-ExtUtils-Embed perl-libwww-perl protobuf-devel python-devel python-pip readline-devel redhat-lsb rpm-build swig tcl tcsh texinfo tk-devel unzip uuid-devel wget which xrootd xrootd-server xrootd-client xrootd-client-devel xrootd-python yum-plugin-priorities zip zlib-devel zlib-static zsh strace net-tools xz

echo "Installing Zulu Java"
wget --no-check-certificate https://cdn.azul.com/zulu/bin/zulu11.68.17-ca-jdk11.0.21-linux.x86_64.rpm && yum -y install zulu11.68.17-ca-jdk11.0.21-linux.x86_64.rpm && rm zulu11.68.17-ca-jdk11.0.21-linux.x86_64.rpm

cd

yum clean all
yum update -y
echo "finally done"