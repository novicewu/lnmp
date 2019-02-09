#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

apt-get update && apt-get upgrade
apt-get install curl wget -y

echo -e “
deb http://mirrors.asnet.am/dotdeb/ jessie all
deb-src http://mirrors.asnet.am/dotdeb/ jessie all” >>/etc/apt/sources.list

wget https://www.dotdeb.org/dotdeb.gpg
apt-key add dotdeb.gpg

apt-get update && apt-get upgrade

apt-get install nginx -y

apt-get install php7.0 php7.0-cgi php7.0-cli php7.0-fpm php7.0-mysql php7.0-odbc php7.0-opcache -y

php -v
