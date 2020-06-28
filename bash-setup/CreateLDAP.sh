#!/bin/bash
. /testVOEnv.sh
ldap_config="${HOME}/.j/testVO/config/ldap.config"
ldap_home="${HOME}/.j/testVO/slapd"
tvo_bin="${HOME}/.j/testVO/bin"
ldap_log="${HOME}/.j/testVO/logs/ldap.log"
ldap_conf_dir="${ldap_home}/slapd.d"
ldap_conf_cn_dir="${ldap_conf_dir}/cn=config"
ldap_pid=""
ldap_pass="pass"
ldap_schema_zip="/jalien/testsys/ldap_schema_config.zip"
ldap_port="8389"
ldap_temp_file="${ldap_home}/ldap_temp.ldif"

function die(){ 
	if [[ $? -ne 0 ]]; then {
		echo "$1"
		exit 1
	}
	fi
}

function createConfig(){
    mkdir -p $ldap_conf_cn_dir
    touch ${ldap_config}
    cp "/jalien/docker-setup/ldap/cn=config.ldif"  "${ldap_conf_dir}"
    cp "/jalien/docker-setup/ldap/olcDatabase={0}config.ldif" "${ldap_conf_cn_dir}"
    cp "/jalien/docker-setup/ldap/olcDatabase={-1}frontend.ldif" "${ldap_conf_cn_dir}"
    cp "/jalien/docker-setup/ldap/olcDatabase={1}hdb.ldif" "${ldap_conf_cn_dir}"
	cp "/jalien/docker-setup/ldap/olcBackend={0}hdb.ldif" "${ldap_conf_cn_dir}"
	cp "/jalien/docker-setup/ldap/cn=module{0}.ldif" "${ldap_conf_cn_dir}"
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
	arr=(add_domain add_org add_packages add_institutions add_partitions add_people add_roles add_services add_sites)
	for i in ${arr[@]}
	do
		echo $i
		ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f "/jalien/docker-setup/ldap/${i}.ldif"
	done
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f /jalien/docker-setup/ldap/ldap_init.ldif
}

function getUserHome(){
	sub_string=$(echo $1 | cut -c1)
	echo "${base_home_dir}${sub_string}/$1/"
}

function addUserToLDAP(){
ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f "/jalien/docker-setup/ldap/add_user_${1}.ldif"
}

function addRoleToLDAP(){
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f "/jalien/docker-setup/ldap/add_role_${1}.ldif"
}

function addSiteToLDAP(){
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f "/jalien/docker-setup/ldap/add_site_jtest.ldif"
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f "/jalien/docker-setup/ldap/add_config_jtest.ldif"
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f "/jalien/docker-setup/ldap/add_services_jtest.ldif"
	arr=("SE" "CE" "FTD" "PackMan")
	for i in ${arr[@]}
	do
		ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f "/jalien/docker-setup/ldap/add_${i}_jtest.ldif"
	done
}

function addSEToLDAP(){
	ldapadd -x -w ${ldap_pass} -h localhost -p ${ldap_port} -D cn=Manager,dc=localdomain -f "/jalien/docker-setup/ldap/add_SE_firstse.ldif"
}

function main(){
    (
        set -e
        if [[ ! -z $1 && "$1" = "addUserToLDAP" ]]; then {
            addUserToLDAP $2
        }
        elif [[ ! -z $1 && "$1" = "addRoleToLDAP" ]]; then {
            addRoleToLDAP $3
        }
        elif [[ ! -z $1 && "$1" = "addSiteToLDAP" ]]; then {
            addSiteToLDAP
        }
        elif [[ ! -z $1 && "$1" = "addSEToLDAP" ]]; then {
            addSEToLDAP
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