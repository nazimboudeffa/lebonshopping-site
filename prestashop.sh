#!/bin/bash

NORMAL="\\033[0;39m"
VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
ROSE="\\033[1;35m"
BLEU="\\033[1;34m"
BLANC="\\033[0;02m"
BLANCLAIR="\\033[1;08m"
JAUNE="\\033[1;33m"
CYAN="\\033[1;36m"

url_BO=''
version=''

function init(){
	echo -e "$NORMAL"
	echo -e "$VERT""------------------ ""$ROUGE""Script Installation Prestashop 1.7.x for SAS Web R&D Informatique""$VERT"" --------------------"
	echo -e "$VERT""|                  ""$BLEU""Written by Antoine Rennesson" "$CYAN""(antoine.Rennesson@web-rd-info.fr)""$VERT""                      |"
	echo -e "$VERT""|                  ""$BLEU""Updated by Julien Mutzenhardt" "$CYAN""(contact@web-rd-info.fr)""$VERT""                               |"
	echo -e "$VERT""|                  ""$BLEU""Inspire Color bash script Selim b." "$CYAN""(s.bouras@free.fr)""$VERT""                                |" 
	echo -e "$VERT""---------------------------------------------------------------------------------------------------------"
	echo -e "$NORMAL"
}

function option(){
	echo -e "$VERT" "option :"
	echo -e "$VERT" "\t-o                                  : Show Option."
	echo -e "$VERT" "\t-d                                  : download file zip last version Prestashop $last_verion."
	echo -e "$VERT" "\t-u                                  : uncompress file zip Prestashop."
	echo -e "$VERT" "\t-i                                  : install cli Prestashop."
	echo -e "$VERT" "\t-s                                  : install binaire Prestashop in /usr/bin."
	echo -e "$VERT" "\t-c                                  : clear file zip Prestashop."
	echo -e "$VERT" "\t-v                                  : Show last version Prestashop"
	echo -e "$VERT" "\t-t                                  : install test (the URL of the site/test)"
	echo -e "$VERT" "\t-f                                  : install FOP"
	echo -e "$BLEU""Press <Enter> to continue ...""$NORMAL"
	read touche
}

function readme(){
	cat ./README.md
	echo -e "$BLEU""Press <Enter> to continue ...""$NORMAL"
	read touche
}

function lastersion(){
	version=$(curl --silent "https://api.github.com/repos/prestashop/prestashop/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
}

function download(){
	if [ -z "$version" ]
	then
	    lastersion
	fi
	url="https://github.com/PrestaShop/PrestaShop/releases/download/version/prestashop_version.zip"
	link="${url//version/$version}"

	echo -e "$VERT""download prestashop from $link"
	echo -e "$NORMAL"

	curl -o "prestashop_$version.zip" "${link}" -O -J -L
}

function fop(){
	url=$(curl --silent "https://api.github.com/repos/friends-of-presta/fop_console/releases/latest" | grep -Po '"browser_download_url": "\K.*?(?=")')

	echo -e "$VERT""install fop_console from $url"
	echo -e "$NORMAL"

	rm -rf ./modules/fop_console/
	cd modules 
	curl -o "fop_console.zip" "${url}" -O -J -L
	unzip -o "fop_console.zip"
	rm -rf "./fop_console.zip"
	cd fop_console
	composer install --no-interaction
	cd ../../
	php bin/console pr:mo install fop_console
}

function test(){
	url="https://github.com/PrestaShop/php-ps-info/archive/v1.1.zip"
	curl -o "test.zip" "${url}" -O -J -L
	unzip -o "test.zip"
	rm -rf "./test.zip"
	rm -rf "./test"
	mv php-ps-info-1.1 test
	mv ./test/phppsinfo.php ./test/index.php

	echo -e "$VERT""the URL of the site/test/"
	echo -e "$VERT""login : prestashop"
	echo -e "$VERT""password : prestashop"
	echo -e "$NORMAL"
}

function uncompress(){
	if [ -z "$version" ]
	then
	    lastersion
	fi
	unzip -o "prestashop_$version.zip"
	unzip -o "prestashop.zip"
	rm -rf "./Install_PrestaShop.html"
	chmod 777 ../ -R
}

function install(){
	if [ -z "$domain" ] || [ -z "$shop_name" ] || [ -z "$firstname" ] || [ -z "$lastname" ] || [ -z "$country" ] || [ -z "$email" ] || [ -z "$password" ] || \
	[ -z "$db_server" ] || [ -z "$db_name" ] || [ -z "$db_user" ] || [ -z "$db_password" ] || [ -z "$db_create" ] || \
	[ -z "$language" ] || [ -z "$ssl" ] || [ -z "$send_email" ]
	then
		reset
		init
	fi
	if [ -z "$domain" ]
	then
		read -r -p 'domain: ' domain
	fi
	if [ -z "$shop_name" ]
	then
		read -r -p 'shop name: ' shop_name
	fi
	if [ -z "$firstname" ]
	then
		read -r -p 'firstname: ' firstname
	fi
	if [ -z "$lastname" ]
	then
		read -r -p 'lastname: ' lastname
	fi
	if [ -z "$country" ]
	then
		read -r -p 'country: ' country
	fi
	if [ -z "$email" ]
	then
		read -r -p 'email: ' email
	fi
	if [ -z "$password" ]
	then
		read -r -s -p  'password: ' password
	fi

	echo -e "\n"
	if [ -z "$db_server" ]
	then
		read -r -p 'database server [localhost]: ' db_server
		if [ -z "$db_server" ]
		then
	    	db_server="localhost"
		fi
	fi
	if [ -z "$db_name" ]
	then
		read -r -p 'database name: ' db_name
	fi
	if [ -z "$db_user" ]
	then
		read -r -p 'database user: ' db_user
	fi
	if [ -z "$db_password" ]
	then
		read -r -s -p 'database password: ' db_password; echo
	fi
	if [ -z "$db_create" ]
	then
		read -p "Create database ([y]/n) ? " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
	    	db_create=1
	    elif [[ $REPLY =~ ^[Nn]$ ]]
	    then
	    	db_create=0
	    else
	    	db_create=1
		fi
	fi

	echo -e "\n"
	if [ -z "$language" ]
	then
		read -r -p 'language [fr]: ' language
		if [ -z "$language" ]
		then
	    	language="fr"
		fi
	fi
	if [ -z "$ssl" ]
	then
		read -r -p 'enable ssl ([y]/n) ? ' -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
	    	ssl=1
	    elif [[ $REPLY =~ ^[Nn]$ ]]
	    then
	    	ssl=0; echo
	    else
	    	ssl=1
		fi
	fi
	if [ -z "$send_email" ]
	then
		read -r -p 'send email ([y]/n) ? ' -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
	    	send_email=1
	    elif [[ $REPLY =~ ^[Nn]$ ]]
	    then
	    	send_email=0
	    else
	    	send_email=1
		fi
	fi

	if [ "$force" = 1 ]
	then
		echo -e ""
		echo -e "$VERT"
	    commande_cli $domain $db_server $db_name $db_user $db_password $db_create $shop_name $ssl $language $firstname $lastname $email $password $send_email
	else
		init
		echo -e "\n"
		echo -e "User"
		echo -e "$NORMAL" "domain : $domain"
		echo -e "$NORMAL" "shop name : $shop_name"
		echo -e "$NORMAL" "firstname : $firstname"
		echo -e "$NORMAL" "lastname : $lastname"
		echo -e "$NORMAL" "country : $country"
		echo -e "$NORMAL" "email : $email"
		echo -e "$NORMAL" "password : $password"
		echo -e "\n"
		echo -e "Database"
		echo -e "$NORMAL" "database server : $db_server"
		echo -e "$NORMAL" "database name : $db_name"
		echo -e "$NORMAL" "database user : $db_user"
		echo -e "$NORMAL" "database password : $db_password"
		echo -e "$NORMAL" "create database ? $db_create"
		echo -e "\n"
		echo -e "Config"
		echo -e "$NORMAL" "language : $language"
		echo -e "$NORMAL" "enable ssl ? $ssl"
		echo -e "$NORMAL" "send email ? $send_email"

		read -r -p 'this information are correct ? '  -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			echo -e ""
			echo -e "$VERT"
		    commande_cli $domain $db_server $db_name $db_user $db_password $db_create $shop_name $ssl $language $firstname $lastname $email $password $send_email
	    else
	    	echo -e "$NORMAL"
	        exit 0;
		fi
	fi
	if [ "$log" = 1 ]
	then
		if [ "$ssl" = 0 ]
		then
			http="http://"
		else
			http="https://"
		fi

		echo "----------------------" >> ./create_shop.log
		echo "url du BO : $http$url_BO" >> ./create_shop.log
		echo "" >> ./create_shop.log
		echo "admin account :" >> ./create_shop.log
		echo "firstname : $firstname" >> ./create_shop.log
		echo "lastname : $lastname" >> ./create_shop.log
		echo "login : $email" >> ./create_shop.log
		echo "password : $password" >> ./create_shop.log
		echo "----------------------" >> ./create_shop.log
		echo "" >> ./create_shop.log
		echo -e "$ROUGE""delete file create_shop.log after installation !!!"
	fi 
}

function commande_cli(){
	file_install="./install/index_cli.php"
	php $file_install \
			--domain="${1}" \
			--db_server="${2}" --db_name="${3}" \
			--db_user="${4}" --db_password="${5}" \
			--db_create="${6}" \
			--name="${7}" \
			--country=fr \
			--ssl="${8}" \
			--language="${9}" \
			--firstname="${10}" \
			--lastname="${11}" \
			--email="${12}" \
			--password="${13}" \
			--send_email="${14}"
	rm -rf "./install"
	chmod 777 ../ -R
	curl -L --silent "${1}/admin" > /dev/null
	url_BO="${1}/$(ls -1 "$PWD" | grep "admin*")"

	if [ "${8}" = 0 ]
	then
		http="http://"
	else
		http="https://"
	fi

	echo "url Back Office : $http$url_BO"
}

function clear(){
	if [ -z "$version" ]
	then
	    lastersion
	fi
	rm -rf "./prestashop_$version.zip"
	rm -rf "./prestashop.zip"
	rm -rf "./prestashop"
	rm -rf "./test"
	rm -rf "./.git"
}

function setup(){
    cp -fn ./prestashop /usr/bin/
    echo -e "$NORMAL""prestashop installed in /usr/bin"
}

OPTS=`getopt -o c,d,o,i,u,v,s,t,f \
--long help,all,version:,domain:,shop_name:,firstname:,lastname:,country:,email:,password:,language:,db_server:,db_name:,db_user:,db_password:,db_create:,ssl:,send_email:,force:,log: -- "$@"`
if [ $# -eq 0 ]
then
	init
    option
    echo -e "$NORMAL"
fi
 
eval set -- "$OPTS"

while true ; do
    case "$1" in
        --version)
            version=$2;
            shift 2;;
        --domain)
            domain=$2;
            shift 2;;
        --shop_name)
            shop_name=$2;
            shift 2;;
        --firstname)
            firstname=$2;
            shift 2;;
        --lastname)
            lastname=$2;
            shift 2;;
        --country)
            country=$2;
            shift 2;;
        --email)
            email=$2;
            shift 2;;
        --password)
            password=$2;
            shift 2;;
        --language)
            language=$2;
            shift 2;;
        --db_server)
            db_server=$2;
            shift 2;;
        --db_name)
            db_name=$2;
            shift 2;;
        --db_user)
            db_user=$2;
            shift 2;;
        --db_password)
            db_password=$2;
            shift 2;;
        --db_create)
            db_create=$2;
            shift 2;;
        --ssl)
            ssl=$2;
            shift 2;;
        --send_email)
            send_email=$2;
            shift 2;;
        --force)
            force=$2;
            shift 2;;
        --log)
            log=$2;
            shift 2;;
        --help) reset
			init;
			readme;
          echo -e "$NORMAL"
          exit 0;
          shift;;
        --all) reset
			init;
			download;
			uncompress;
			reset;
			install;
			test;
			fop;
			clear;
            echo -e "$NORMAL"
            exit 0;
            shift;;
        -c) clear;
            shift;; 
        -d) download;
            shift;;                    
        -o) option;
            echo -e "$NORMAL"
            exit 0;
            shift;;
        -i) install;
			shift;;
		-s) setup;
			shift;;
        -u) uncompress;
            shift;;
        -t) test;
            shift;;
        -v) lastersion;
            echo $version
            shift;;
        -f) fop;
            shift;;
        --) break ;;
        *) ;;
    esac
done
echo -e "$NORMAL"