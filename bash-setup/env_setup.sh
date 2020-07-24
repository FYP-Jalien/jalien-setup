#!/bin/bash
certpath=

export ALIENPY_JCENTRAL="127.0.0.1"
export X509_CERT_DIR="${certpath}/globus"
export X509_USER_CERT="${X509_CERT_DIR}/usercert.pem"
export X509_USER_KEY="${X509_CERT_DIR}/userkey.pem"
export JALIEN_TOKEN_CERT="${X509_CERT_DIR}/usercert.pem"
export JALIEN_TOKEN_KEY="${X509_CERT_DIR}/userkey.pem"
export JALIEN_HOST="127.0.0.1"
export JALIEN_WSPORT="8097"
