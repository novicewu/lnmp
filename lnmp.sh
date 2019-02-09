#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# System Requirement Debian 8

apt-get update
apt-get install curl wget -y

echo -e "
deb http://ftp.us.debian.org/debian/ jessie main
deb-src http://ftp.us.debian.org/debian/ jessie main

deb http://security.debian.org/ jessie/updates main
deb-src http://security.debian.org/ jessie/updates main

# jessie-updates, previously known as 'volatile'
deb http://ftp.us.debian.org/debian/ jessie-updates main
deb-src http://ftp.us.debian.org/debian/ jessie-updates main

deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all" >/etc/apt/sources.list

wget https://www.dotdeb.org/dotdeb.gpg
apt-key add dotdeb.gpg

apt-get update

apt-get install nginx -y

apt-get install php7.0 php7.0-cgi php7.0-cli php7.0-fpm php7.0-mysql php7.0-odbc php7.0-opcache -y

php -v
