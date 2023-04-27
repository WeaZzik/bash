#!/bin/bash
yes | apt-get update
yes | apt install ca-certificates apt-transport-https software-properties-common curl lsb-release
yes | curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
yes | apt-get update
yes | apt install php8.1 libapache2-mod-php8.1 php8.1-fpm php8.1-cli php8.1-common php8.1-curl php8.1-bcmath php8.1-intl php8.1-mbstring php8.1-xmlrpc php8.1-mcrypt php8.1-mysql php8.1-gd php8.1-xml php8.1-cli php8.1-zip php8.1-mysqli
yes | apt install mariadb-server zip apache2 fail2ban
echo -e "\n&\nn\ny\nNot24get@IIA\nNot24get@IIA\ny\ny\ny\ny\n" | mysql_secure_installation
rm -r /var/www/temp
mkdir /var/www/temp
touch /var/www/temp/index.php
chmod +u+r+x /var/www/temp/index.php
echo "<?php" > /var/www/temp/index.php
echo "phpinfo()" >> /var/www/temp/index.php
echo "?>" >> /var/www/temp/index.php
touch /etc/apache2/sites-available/temp.conf
chmod /etc/apache2/sites-available/temp.conf
echo "<VirtualHost *:80>" > /etc/apache2/sites-available/temp.conf
echo "	ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/temp.conf
echo "	DocumentRoot /var/www/temp" >> /etc/apache2/sites-available/temp.conf
echo "" >> /etc/apache2/sites-available/temp.conf
echo "	ErrorLog ${APACHE_LOG_DIR}/temp_error.log" >> /etc/apache2/sites-available/temp.conf
echo "	CustomLog ${APACHE_LOG_DIR}/temp_access.log combined" >> /etc/apache2/sites-available/temp.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/temp.conf
a2enmod rewrite
a2dismod headers
a2dissite 000-default.conf
a2ensite temp.conf
systemctl restart apache2
echo "----------------"
echo "END OF SCRIPT"
echo "----------------"