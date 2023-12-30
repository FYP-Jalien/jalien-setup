#!/bin/bash
set -e
yum update -y
yum install -y wget
wget --no-check-certificate https://cdn.azul.com/zulu/bin/zulu11.68.17-ca-jdk11.0.21-linux.x86_64.rpm && yum -y install zulu11.68.17-ca-jdk11.0.21-linux.x86_64.rpm && rm zulu11.68.17-ca-jdk11.0.21-linux.x86_64.rpm
yum clean all
yum update -y