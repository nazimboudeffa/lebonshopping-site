# Le Bon Shopping

Many thanks to [@flybaby57](https://twitter.com/flybaby57) for [the installation script](https://forge.web-rd-info.fr/open/install_cli_prestashop/-/tree/master)

## Installation

```
git clone https://forge.web-rd-info.fr/webrdinfo/install_cli_prestashop.git ./
./prestashop --parameter ? -option
```
show option :

```
./prestashop -o
```

Usable parameter :

```
parameter (description) : example

help (show help) : --help
version (download version prestashop with argument ?) : --version 1.7.x.x
all (Install Prestashop with sequence download -> uncompress -> install prestashop, test, fop => equivalent at -d -u -i -c -t -f) : --all
force (force the installation without prompting for confirmation 1 for yes or 0 for no) : --force 1
log (log the installation in ./create_shop.log 1 for yes or 0 for no) : --Log 1

domain : --domain www.xxxx.fr
shop_name : --shop_name myshop
firstname : --firstname Julien
lastname : --lastname Mutzenhardt
country : --country france
email : --email contact@web-rd-info.fr
password : --password xxxxxxxx

db_server (database server) : --db_server Localhost
db_name (database name) : --db_name prestashop
db_user (database user) : --db_user root
db_password (database password) : --db_password xxxxxxxx
db_create (create database 1 for yes or 0 for no) : --db_create 1 

language : --language fr
ssl (enable ssl 1 for yes or 0 for no) : --ssl 1
send_email (send an email to the user when the installation is finished 1 for yes or 0 for no) : --send_email 1

```

Using the script :
```
./prestashop --version 1.7.4.1 --domain www.xxxx.fr --shop_name myshop --firstname julien --lastname mutzenhardt --country france --email contact@web-rd-info.fr --password xxxxxxxx --language fr --db_server localhost --db_name prestashop --db_user root --db_password xxxxxxxx --db_create 1 --ssl 0 --send_email 0 --log 1 --force 1 --all
```

