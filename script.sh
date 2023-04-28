#!/bin/bash
website_url=$(hostname -I)
website_name="temp"
echo "install apache2 ?"
read apache2_choice
echo "install mariadb ?"
read mariadb_choice
echo "install php8.1 ?"
read php_choice
echo "enable fail2ban ?"
read fail2ban_choice
echo "create a website ?"
read website_choice
if [ "$website_choice" = "" ] || [ "$website_choice" = "Y" ] || [ "$website_choice" = "y" ]
then
  echo "website name (ex: wordpress, nextcloud..) :"
  read website_name
fi
echo "define a custom url ?"
read url_choice
if [ "$url_choice" = "" ] || [ "$url_choice" = "Y" ] || [ "$url_choice" = "y" ]
then
  echo "URL (ex : temp.fr ) :"
  read url_name
fi
echo "create a mysql database ?"
read database_choice
if [ "$database_choice" = "" ] || [ "$database_choice" = "Y" ] || [ "$database_choice" = "y" ]
then
  echo "name (ex: wordpress, nextcloudDB..) :"
  read database_name
fi
echo "create a mysql service account ?"
read dbaccount_choice
if [ "$dbaccount_choice" = "" ] || [ "$dbaccount_choice" = "Y" ] || [ "$dbaccount_choice" = "y" ]
then
  echo "name (ex: wordpress, nextcloudDBuser..) :"
  read dbaccount_name
fi
echo "hide web server informations from public ?"
read servertokens_choice

yes | apt-get update

if [ "$php_choice" = "" ] || [ "$php_choice" = "Y" ] || [ "$php_choice" = "y" ]
then
  yes | apt install ca-certificates apt-transport-https software-properties-common curl lsb-release
  yes | curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
  yes | apt-get update
yes | apt install php8.1 libapache2-mod-php8.1 php8.1-fpm php8.1-cli php8.1-common php8.1-curl php8.1-bcmath php8.1-intl php8.1-mbstring php8.1-xmlrpc php8.1-mcrypt php8.1-mysql php8.1-gd php8.1-xml php8.1-cli php8.1-zip php8.1-mysqli
fi

if [ "$mariadb_choice" = "" ] || [ "$mariadb_choice" = "Y" ] || [ "$mariadb_choice" = "y" ]
then
  yes | apt install mariadb-server
  echo -e "\n&\nn\ny\nNot24get@IIA\nNot24get@IIA\ny\ny\ny\ny\n" | mysql_secure_installation
fi

if [ "$apache2_choice" = "" ] || [ "$apache2_choice" = "Y" ] || [ "$apache2_choice" = "y" ]
then
  yes | apt install zip apache2 python3-certbot-apache certbot
  a2enmod rewrite
  a2enmod env
  a2enmod dir
  a2enmod mime
  a2enmod headers
  echo "Yes, do as I say!" | a2dismod autoindex
fi

if [ "$fail2ban_choice" = "" ] || [ "$fail2ban_choice" = "Y" ] || [ "$fail2ban_choice" = "y" ]
then
  yes | apt install fail2ban
fi

if [ "$website_choice" = "" ] || [ "$website_choice" = "Y" ] || [ "$website_choice" = "y" ]
then
  rm -r /var/www/$website_name
  mkdir /var/www/$website_name
  touch /var/www/$website_name/index.php
  chmod +u+r+x /var/www/$website_name/index.php
  echo "<?php" > /var/www/$website_name/index.php
  echo "phpinfo()" >> /var/www/$website_name/index.php
  echo "?>" >> /var/www/$website_name/index.php
  rm -r /etc/apache2/sites-available/$website_name.conf
  touch /etc/apache2/sites-available/$website_name.conf
  echo "<VirtualHost *:80>" > /etc/apache2/sites-available/$website_name.conf
  echo "	ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/$website_name.conf
  echo "	DocumentRoot /var/www/$website_name" >> /etc/apache2/sites-available/$website_name.conf
  echo "	ServerName $website_url" >> /etc/apache2/sites-available/$website_name.conf
  echo "" >> /etc/apache2/sites-available/$website_name.conf
  echo '	ErrorLog ${APACHE_LOG_DIR}/site_error.log' >> /etc/apache2/sites-available/$website_name.conf
  echo '	CustomLog ${APACHE_LOG_DIR}/site_access.log combined' >> /etc/apache2/sites-available/$website_name.conf
  echo "</VirtualHost>" >> /etc/apache2/sites-available/$website_name.conf
  a2dissite 000-default.conf
  a2ensite $website_name.conf
fi

if [ "$servertokens_choice" = "" ] || [ "$servertokens_choice" = "Y" ] || [ "$servertokens_choice" = "y" ]
then
  sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-enabled/security.conf
fi

if [ "$apache2_choice" = "" ] || [ "$apache2_choice" = "Y" ] || [ "$apache2_choice" = "y" ]
then
  systemctl restart apache2
fi
echo "----------------"
echo "END OF SCRIPT"
echo "----------------"
echo "> temp site url : http://$website_url"
echo "> mysql root password : Not24get@IIA"
echo "----------------"
