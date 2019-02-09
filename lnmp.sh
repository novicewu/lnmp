#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# System Requirement Debian 8

#Define Variables
echo && read -e -p "请输入域名(不要带www, 例如: baidu.com): " web_url
echo && read -e -p "请输入网站路径(例如:/var/www/html, 最后不用带/): " web_path

apt-get update

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

# Config Nginx
echo -e "
server {
	listen 80;
	server_name $web_url www.$web_url;
	root $web_path;
	index index.php index.html index.htm index.nginx-debian.html;

	location / {
		try_files \$uri \$uri/ =404;
	}

	error_page 404 /404.html;
	error_page 500 502 503 504 /50x.html;

	location = /50x.html {
		root $web_path;
	}

	location ~ \\.php\$ {
		try_files \$uri =404;
		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
		include fastcgi_params;
	}
}" >/etc/nginx/sites-available/$web_url.conf


ln -s /etc/nginx/sites-available/$web_url.conf /etc/nginx/sites-enabled/$web_url.conf

nginx -t
service nginx reload
chmod -R 755 $web_path && chown www-data:www-data $web_path -R

# Install Wordpress
cd /$web_path
wget https://cn.wordpress.org/wordpress-4.9.4-zh_CN.tar.gz
tar -zxvf wordpress-4.9.4-zh_CN.tar.gz
mv wordpress/* .
rm -rf wordpress
rm -rf wordpress-4.9.4-zh_CN.tar.gz
chmod -R 755 $web_path && chown www-data:www-data $web_path -R

# Install Let’s Encrypt
cd /root
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto

echo -e "
server {
    root $web_path;
    server_name $web_url;
    index  index.html index.htm index.php;

    location ~ \\.php(.*)\$  {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_split_path_info  ^((?U).+\\.php)(/?.+)\$;
        fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
        fastcgi_param  PATH_INFO  \$fastcgi_path_info;
        fastcgi_param  PATH_TRANSLATED  \$document_root\$fastcgi_path_info;
        include        fastcgi_params;
    }
}" >/etc/nginx/conf.d/$web_url.conf

systemctl restart nginx

# Daily Check Certificate



