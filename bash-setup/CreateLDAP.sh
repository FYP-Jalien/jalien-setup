#!/bin/bash
ldap_module_path="/usr/lib/ldap"
ldap_config="${HOME}/.j/testVO/config/ldap.config"
ldap_home="${HOME}/.j/testVO/slapd"
tvo_bin="${HOME}/.j/testVO/bin"
ldap_log="${HOME}/.j/testVO/logs/ldap.log"
ldap_conf_dir="${ldap_home}/slapd.d"
ldap_conf_cn_dir="${ldap_conf_dir}/cn=config"
ldap_args_file="/tmp/jalien-slapd.args"
ldap_pid_file="/tmp/jalien-slapd.pid"
ldap_starter="${tvo_bin}/LDAP_starter"
ldap_pid=""
ldap_suffix="dc=localdomain"
ldap_root="o=localhost,${ldap_suffix}"
ldap_cred="cn=Manager,${ldap_suffix}"
ldap_pass="pass"
ldap_schema_zip="${JALIEN_HOME}/testsys/ldap_schema_config.zip"
ldap_port="8389"
certSubjectuser="/C=CH/O=JAliEn/CN=jalien"
base_home_dir="/localhost/localdomain/user/"

ldap_conf_cn_file="${ldap_conf_dir}/cn=config.ldif"
ldap_conf_cn_file_content="dn: cn=config
objectClass: olcGlobal
cn: config
olcConfigDir: slapd.d
olcArgsFile: ${ldap_args_file}
olcAttributeOptions: lang-
olcAuthzPolicy: none
olcConcurrency: 0
olcConnMaxPending: 100
olcConnMaxPendingAuth: 1000
olcGentleHUP: FALSE
olcIdleTimeout: 0
olcIndexSubstrIfMaxLen: 4
olcIndexSubstrIfMinLen: 2
olcIndexSubstrAnyLen: 4
olcIndexSubstrAnyStep: 2
olcIndexIntLen: 4
olcLocalSSF: 71
olcPidFile: ${ldap_pid_file}
olcReadOnly: FALSE
olcReverseLookup: FALSE
olcSaslSecProps: noplain,noanonymous
olcSockbufMaxIncoming: 262143
olcSockbufMaxIncomingAuth: 16777215
olcThreads: 16
olcTLSVerifyClient: never
olcToolThreads: 1
olcWriteTimeout: 0
structuralObjectClass: olcGlobal
entryUUID: 3ea36e88-928c-1030-8269-d50de8eaff50
creatorsName: cn=config
createTimestamp: 20111024130300Z
entryCSN: 20111024130300.108563Z#000000#000#000000
modifiersName: cn=config
modifyTimestamp: 20111024130300Z"

ldap_conf_db_config_file="${ldap_conf_cn_dir}/olcDatabase={0}config.ldif"
ldap_conf_db_config_file_contents="dn: olcDatabase={0}config
objectClass: olcDatabaseConfig
olcDatabase: {0}config
olcAccess: {0}to *  by * none
olcAddContentAcl: TRUE
olcLastMod: TRUE
olcMaxDerefDepth: 15
olcReadOnly: FALSE
olcSyncUseSubentry: FALSE
olcMonitoring: FALSE
structuralObjectClass: olcDatabaseConfig
entryUUID: 3ea3de2c-928c-1030-8270-d50de8eaff50
creatorsName: cn=config
createTimestamp: 20111024130300Z
entryCSN: 20111024130300.108563Z#000000#000#000000
modifiersName: cn=config
modifyTimestamp: 20111024130300Z"

ldap_conf_db_frontend_file="${ldap_conf_cn_dir}/olcDatabase={-1}frontend.ldif"
ldap_conf_db_frontend_file_contents="dn: olcDatabase={-1}frontend
objectClass: olcDatabaseConfig
objectClass: olcFrontendConfig
olcDatabase: {-1}frontend
olcAddContentAcl: FALSE
olcLastMod: TRUE
olcMaxDerefDepth: 0
olcReadOnly: FALSE
olcSchemaDN: cn=Subschema
olcSyncUseSubentry: FALSE
olcMonitoring: FALSE
structuralObjectClass: olcDatabaseConfig
entryUUID: 3ea3db5c-928c-1030-826f-d50de8eaff50
creatorsName: cn=config
createTimestamp: 20111024130300Z
entryCSN: 20111024130300.108563Z#000000#000#000000
modifiersName: cn=config
modifyTimestamp: 20111024130300Z"

ldap_conf_db_hdb_file="${ldap_conf_cn_dir}/olcDatabase={1}hdb.ldif"
ldap_conf_db_hdb_file_contents="dn: olcDatabase={1}hdb
objectClass: olcDatabaseConfig
objectClass: olcHdbConfig
olcDatabase: {1}hdb
olcDbDirectory: ${ldap_home}
olcSuffix: ${ldap_suffix}
olcAccess: {0}to attrs=userPassword,shadowLastChange by self write by anonymous auth by dn=\"${ldap_cred}\" write by * none
olcAccess: {1}to dn.base=\"\" by * read
olcAccess: {2}to * by self write by dn=\"${ldap_cred}\" write by * read
olcLastMod: TRUE
olcRootDN: ${ldap_cred}
olcRootPW: ${ldap_pass}
olcDbCheckpoint: 512 30
olcDbConfig: {0}set_cachesize 0 2097152 0
olcDbConfig: {1}set_lk_max_objects 1500
olcDbConfig: {2}set_lk_max_locks 1500
olcDbConfig: {3}set_lk_max_lockers 1500
olcDbIndex: objectClass eq
structuralObjectClass: olcHdbConfig
entryUUID: 95a9db0e-7941-1030-99f4-f301eb8bc9b9
creatorsName: cn=config
createTimestamp: 20110922083534Z
entryCSN: 20110922083534.788341Z#000000#000#000000
modifiersName: cn=config
modifyTimestamp: 20110922083534Z"

ldap_conf_db_backend_file="${ldap_conf_cn_dir}/olcBackend={0}hdb.ldif"
ldap_conf_db_backend_file_contents="dn: olcBackend={0}hdb
objectClass: olcBackendConfig
olcBackend: {0}hdb
structuralObjectClass: olcBackendConfig
entryUUID: 95a9d4e2-7941-1030-99f3-f301eb8bc9b9
creatorsName: cn=config
createTimestamp: 20110922083534Z
entryCSN: 20110922083534.788182Z#000000#000#000000
modifiersName: cn=config
modifyTimestamp: 20110922083534Z"

ldap_conf_db_mod_file="${ldap_conf_cn_dir}/cn=module{0}.ldif"
ldap_conf_db_mod_file_contents="dn: cn=module{0}
objectClass: olcModuleList
cn: module{0}
olcModulePath: ${ldap_module_path}
olcModuleLoad: {0}back_hdb
structuralObjectClass: olcModuleList
entryUUID: 95a9a684-7941-1030-99f2-f301eb8bc9b9
creatorsName: cn=config
createTimestamp: 20110922083534Z
entryCSN: 20110922083534.786996Z#000000#000#000000
modifiersName: cn=config
modifyTimestamp: 20110922083534Z"

ldap_init_file="${JALIEN_HOME}/docker-setup/ldap_init.ldif"

ldap_temp_file="${ldap_home}/ldap_temp.ldif"

ldap_add_domain="dn: ${ldap_suffix}\nobjectClass: top\nobjectClass: domain\ndc: localdomain\n"

ldap_add_org="dn: ${ldap_root}\nobjectClass: top\nobjectClass: organization\no: localhost\n"

ldap_add_packages="dn: ou=Packages,${ldap_root}\nobjectClass: top\nobjectClass: organizationalUnit\nou: Packages\n"

ldap_add_institutions="dn: ou=Institutions,${ldap_root}\nobjectClass: top\nobjectClass: organizationalUnit\nou: Institutions\n"

ldap_add_partitions="dn: ou=Partitions,${ldap_root}\nobjectClass: top\nobjectClass: organizationalUnit\nou: Partitions\n"

ldap_add_people="dn: ou=People,${ldap_root}\nobjectClass: top\nobjectClass: organizationalUnit\nou: People\n"

ldap_add_roles="dn: ou=Roles,${ldap_root}\nobjectClass: top\nobjectClass: organizationalUnit\nou: Roles\n"

ldap_add_services="dn: ou=Services,${ldap_root}\nobjectClass: top\nobjectClass: organizationalUnit\nou: Services\n"

ldap_add_sites="dn: ou=Sites,${ldap_root}\nobjectClass: top\nobjectClass: organizationalUnit\nou: Sites\n"


function die(){ 
	if [[ $? -ne 0 ]]; then {
		echo "$1"
		exit 1
	}
	fi
}

function createConfig(){
    mkdir -p $ldap_conf_cn_dir
    touch ${ldap_conf_cn_file} ${ldap_conf_db_config_file} ${ldap_conf_db_frontend_file} ${ldap_conf_db_hdb_file} ${ldap_conf_db_backend_file} ${ldap_conf_db_mod_file} ${ldap_config}
    echo -e "${ldap_conf_cn_file_content}" > "${ldap_conf_cn_file}"
    echo -e "${ldap_conf_db_config_file_contents}" > "${ldap_conf_db_config_file}"
    echo -e "${ldap_conf_db_frontend_file_contents}" > "${ldap_conf_db_frontend_file}"
    echo -e "${ldap_conf_db_hdb_file_contents}" > "${ldap_conf_db_hdb_file}"
	echo -e "${ldap_conf_db_backend_file_contents}" > "${ldap_conf_db_backend_file}"
	echo -e "${ldap_conf_db_mod_file_contents}" > "${ldap_conf_db_mod_file}"
	echo -e "password=${ldap_pass}\n" > "${ldap_config}"
}

function extractLDAPSchema(){
	#needed unzip dependency
	unzip -u $ldap_schema_zip -d $ldap_conf_cn_dir
}

function startLDAP(){
	nohup slapd -d -1 -s 0 -h ldap://:${ldap_port} -F ${ldap_conf_dir} > ${ldap_log} 2>&1> /dev/null&
}

function initializeLDAP(){
	touch ${ldap_temp_file}
	local IFS="^"
	arr=($ldap_add_domain $ldap_add_org $ldap_add_packages $ldap_add_institutions $ldap_add_partitions $ldap_add_people $ldap_add_roles $ldap_add_services $ldap_add_sites)
	for i in ${arr[@]}
	do
		unset IFS
		echo $i
		echo -e ${i} > ${ldap_temp_file}
		ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_temp_file}
	done
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_init_file}
}

function getUserHome(){
	sub_string=$(echo $1 | cut -c1)
	echo "${base_home_dir}${sub_string}/$1/"
}

function addUserToLDAP(){
	ldap_home_dir=$(getUserHome $1)
	ldap_add_user="dn: uid=${1},ou=People,${ldap_root}\n\
loginShell: false\n\
gidNumber: 1\n\
objectClass: top\n\
objectClass: posixAccount\n\
objectClass: AliEnUser\n\
objectClass: pkiUser\n\
roles: ${3}\n\
uid: ${1}\n\
uidNumber: ${2}\n\
subject: ${4}\n\
cn: ${1}\n\
homeDirectory: ${ldap_home_dir}\n\
userPassword:: e2NyeXB0fXg=\n"
touch ${ldap_temp_file}
echo -e ${ldap_add_user} > ${ldap_temp_file}
ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_temp_file}
}

function addRoleToLDAP(){
	ldap_add_role="dn: uid=${2},ou=Roles,${ldap_root}\n\
objectClass: top\n\
objectClass: AliEnRole\n\
uid: ${2}\n\
users: ${1}\n"
	touch ${ldap_temp_file}
	echo -e ${ldap_add_role} > ${ldap_temp_file}
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_temp_file}
}

function addSiteToLDAP(){
	ldap_add_site="dn: ou=${1},ou=Sites,${ldap_root}\n\
logdir: ${3}\n\
cachedir: ${4}\n\
objectClass: top\n\
objectClass: organizationalUnit\n\
objectClass: AliEnSite\n\
ou: ${1}\n\
domain: ${2}\n\
tmpdir: ${5}\n"
	touch ${ldap_temp_file}
	echo -e ${ldap_add_site} > ${ldap_temp_file}
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_temp_file}
	ldap_add_site="dn: ou=Config,ou=${1},ou=Sites,${ldap_root}\n\
objectClass: top\n\
objectClass: organizationalUnit\n\
ou: Config\n"
	echo -e ${ldap_add_site} > ${ldap_temp_file}
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_temp_file}
	ldap_add_site="dn: ou=Services,ou=${1},ou=Sites,${ldap_root}\n\
objectClass: top\n\
objectClass: organizationalUnit\n\
ou: Services\n"
	echo -e ${ldap_add_site} > ${ldap_temp_file}
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_temp_file}
	arr=("SE" "CE" "FTD" "PackMan")
	for i in ${arr[@]}
	do
		ldap_add_site="dn: ou=${i},ou=Services,ou=${1},ou=Sites,${ldap_root}\n\
objectClass: top\n\
objectClass: organizationalUnit\n\
ou: ${i}"
		echo -e ${ldap_add_site} > ${ldap_temp_file}
		ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_temp_file}
	done
}

function addSEToLDAP(){
	host=$(echo ${3} | cut  -d ":" -f 1)
	port=$(echo ${3} | cut  -d ":" -f 2)
	ldap_add_SE="dn: name=${1},ou=SE,ou=Services,ou=${2},ou=Sites,${ldap_root}\n\
name: ${1}\n\
port: ${port}\n\
ftdprotocol: cp\n\
objectClass: top\n\
objectClass: AliEnSE\n\
objectClass: AliEnMSS\n\
objectClass: AliEnSOAPServer\n\
QoS: ${5}\n\
savedir: ${4}\n\
mss: File\n\
ioDaemons: file:host=${host}:port=${port}\n\
host: ${host}\n"
	touch ${ldap_temp_file}
	echo -e ${ldap_add_SE} > ${ldap_temp_file}
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D ${ldap_cred} -f ${ldap_temp_file}
}

function main(){
    (
        set -e
        if [[ ! -z $1 && "$1" = "addUserToLDAP" ]]; then {
            addUserToLDAP $2 $3 $4 $5
        }
        elif [[ ! -z $1 && "$1" = "addRoleToLDAP" ]]; then {
            addRoleToLDAP $2 $3
        }
        elif [[ ! -z $1 && "$1" = "addSiteToLDAP" ]]; then {
            addSiteToLDAP $2 $3 $4 $5 $6
        }
        elif [[ ! -z $1 && "$1" = "addSEToLDAP" ]]; then {
            addSEToLDAP $2 $3 $4 $5 $6
        }
        else {
			createConfig
			extractLDAPSchema
			startLDAP
			sleep 2
			initializeLDAP
		}
		fi
    )
	die "LDAP failed to setup"
	
    
}

main $1