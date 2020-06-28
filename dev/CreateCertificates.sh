#!/bin/bash

out=$(realpath -m $1)
[ x"$out" == x"" ] && echo "Usage: <out>/{certs,trusts}" && exit 1

TVO_CERTS=$out/globus
TVO_TRUSTS=$out/trusts

mkdir -p $TVO_CERTS $TVO_TRUSTS

function make_CA {
    cert="$1"
    key="$2"
    subj="$3"

    openssl genrsa -out "$key" 1024
    openssl req -new -batch -key "$key" -x509 -days 365 -out "$cert" -subj "$subj"
}

function make_cert() {
    cert="$1"
    key="$2"
    subj="$3"

    openssl req -nodes -newkey rsa:1024 -out "req.pem" -keyout "$key" -subj "$subj"
    openssl x509 -req -in "req.pem" -CA "cacert.pem" -CAkey "cakey.pem" -CAcreateserial -out "$cert"
    rm "req.pem"
}

pushd $TVO_CERTS

make_CA "cacert.pem" "cakey.pem" "/C=CH/O=JAliEn/CN=JAliEnCA"
openssl rehash .
openssl pkcs12 -password pass: -export -in "cacert.pem" -name alien -inkey "cakey.pem" -out "${TVO_TRUSTS}/alien.p12"

make_cert "usercert.pem"  "userkey.pem"    "/C=CH/O=JAliEn/CN=jalien"
make_cert "hostcert.pem"  "hostkey.pem"    "/C=CH/O=JAliEn/CN=localhost.localdomain"
make_cert "AuthZ_pub.pem" "AuthZ_priv.pem" "/C=CH/O=JAliEn/CN=jAuth"
make_cert "SE_pub.pem"    "SE_priv.pem"    "/C=CH/O=JAliEn/CN=TESTSE"

chmod 440 *.pem
popd
