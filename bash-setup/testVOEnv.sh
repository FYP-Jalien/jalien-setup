#!/bin/bash

#for CreateCertificates.sh needs two folders: globus and trusts
[[ -z $custom_jalienpath ]] && new_jalienpath=$HOME || new_jalienpath=$custom_jalienpath

TVO_CERTS="${new_jalienpath}/.j/testVO/globus"
TVO_TRUSTS="${new_jalienpath}/.j/testVO/trusts"
CERTSUBJECT_CA="/C=CH/O=JAliEn/CN=JAliEnCA"
CERTSUBJECT_USER="/C=CH/O=JAliEn/CN=jalien"
CERTSUBJECT_HOST="/C=CH/O=JAliEn/CN=localhost.localdomain"
CERTSUBJECT_JAUTH="/C=CH/O=JAliEn/CN=jAuth"
CERTSUBJECT_SE="/C=CH/O=JAliEn/CN=TESTSE"