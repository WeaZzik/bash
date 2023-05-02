#################### QNA ######################

#!/bin/bash
website_url=$(hostname -I)
website_name="temp"
website_var="http"
echo "install apache2 [Y/n] ?"
read apache2_choice
echo "install mariadb [Y/n] ?"
read mariadb_choice
echo "install php8.1 [Y/n] ?"
read php_choice
echo "enable fail2ban [Y/n] ?"
read fail2ban_choice
echo "create a website [Y/n] ?"
read website_choice
if [ "$website_choice" = "" ] || [ "$website_choice" = "Y" ] || [ "$website_choice" = "y" ]
then
  echo "install wordpress [Y/n] ?"
  read wordpress_choice
  echo "install nextcloud [Y/n] ?"
  read nextcloud_choice
  echo "install glpi [Y/n] ?"
  read glpi_choice
fi
echo "hide web server informations from public [Y/n] ?"
read servertokens_choice


#################### COMMANDS ######################

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
  rm -r /var/www/html
  mkdir /var/www/html
  touch /var/www/html/index.php
  chmod +u+r+x /var/www/html/index.php
  echo "<?php" > /var/www/html/index.php
  echo "phpinfo()" >> /var/www/html/index.php
  echo "?>" >> /var/www/html/index.php
  rm -r /etc/apache2/sites-available/000-default.conf
  touch /etc/apache2/sites-available/000-default.conf
  echo "<VirtualHost *:80>" > /etc/apache2/sites-available/000-default.conf
  echo "	DocumentRoot /var/www/html" >> /etc/apache2/sites-available/000-default.conf
  echo "	ServerName $website_url" >> /etc/apache2/sites-available/000-default.conf
  echo "" >> /etc/apache2/sites-available/000-default.conf
  echo '	ErrorLog ${APACHE_LOG_DIR}/html_error.log' >> /etc/apache2/sites-available/000-default.conf
  echo '	CustomLog ${APACHE_LOG_DIR}/html_access.log combined' >> /etc/apache2/sites-available/000-default.conf
  echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf
  a2dissite 000-default.conf
  a2ensite 000-default.conf
fi

if [ "$wordpress_choice" = "" ] || [ "$wordpress_choice" = "Y" ] || [ "$wordpress_choice" = "y" ]
then
  mysql -e "DROP DATABASE IF EXISTS wordpress;"
  mysql -e "DROP USER IF EXISTS 'wordpress'@'localhost';"
  mysql -e "CREATE DATABASE wordpress /*\!40100 DEFAULT CHARACTER SET utf8 */;"
  mysql -e "CREATE USER wordpress@localhost IDENTIFIED BY 'Not24get@IIA';"
  mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
  rm -r /var/www/wordpress
  mkdir /var/www/wordpress
  wget https://wordpress.org/latest.zip -P /var/www/wordpress
  unzip /var/www/wordpress/latest.zip -d /var/www/wordpress
  mv /var/www/wordpress/wordpress/* /var/www/wordpress
  rm -r /var/www/wordpress/latest.zip
  rm -r /var/www/wordpress/wordpress
  chown -R www-data:www-data /var/www/wordpress
  cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
  sed -i 's/database_name_here/wordpress/' /var/www/wordpress/wp-config.php
  sed -i 's/username_here/wordpress/' /var/www/wordpress/wp-config.php
  sed -i 's/password_here/Not24get@IIA/' /var/www/wordpress/wp-config.php
  rm /var/www/wordpress/readme.html
  rm -r /etc/apache2/sites-available/wordpress.conf
  touch /etc/apache2/sites-available/wordpress.conf
  echo "<VirtualHost *:80>" > /etc/apache2/sites-available/wordpress.conf
  echo "	DocumentRoot /var/www/wordpress" >> /etc/apache2/sites-available/wordpress.conf
  echo "	ServerName $website_url" >> /etc/apache2/sites-available/wordpress.conf
  echo "" >> /etc/apache2/sites-available/wordpress.conf
  echo '	ErrorLog ${APACHE_LOG_DIR}/wordpress_error.log' >> /etc/apache2/sites-available/wordpress.conf
  echo '	CustomLog ${APACHE_LOG_DIR}/wordpress_access.log combined' >> /etc/apache2/sites-available/wordpress.conf
  echo "</VirtualHost>" >> /etc/apache2/sites-available/wordpress.conf
  a2dissite wordpress.conf
  a2ensite wordpress.conf
fi
if [ "$nextcloud_choice" = "" ] || [ "$nextcloud_choice" = "Y" ] || [ "$nextcloud_choice" = "y" ]
then
  mysql -e "DROP DATABASE IF EXISTS nextcloud;"
  mysql -e "DROP USER IF EXISTS 'nextcloud'@'localhost';"
  mysql -e "CREATE DATABASE nextcloud /*\!40100 DEFAULT CHARACTER SET utf8 */;"
  mysql -e "CREATE USER nextcloud@localhost IDENTIFIED BY 'Not24get@IIA';"
  mysql -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
  rm -r /var/www/nextcloud
  mkdir /var/www/nextcloud
  wget https://download.nextcloud.com/server/releases/latest.zip -P /var/www/nextcloud
  unzip /var/www/nextcloud/latest.zip -d /var/www/nextcloud
  mv /var/www/nextcloud/nextcloud/* /var/www/nextcloud
  rm -r /var/www/nextcloud/latest.zip
  rm -r /var/www/nextcloud/nextcloud
  chown -R www-data:www-data /var/www/nextcloud
  rm -r /etc/apache2/sites-available/nextcloud.conf
  touch /etc/apache2/sites-available/nextcloud.conf
  echo "<VirtualHost *:80>" > /etc/apache2/sites-available/nextcloud.conf
  echo "	DocumentRoot /var/www/nextcloud" >> /etc/apache2/sites-available/nextcloud.conf
  echo "	ServerName $website_url" >> /etc/apache2/sites-available/nextcloud.conf
  echo "" >> /etc/apache2/sites-available/nextcloud.conf
  echo '	ErrorLog ${APACHE_LOG_DIR}/nextcloud_error.log' >> /etc/apache2/sites-available/nextcloud.conf
  echo '	CustomLog ${APACHE_LOG_DIR}/nextcloud_access.log combined' >> /etc/apache2/sites-available/nextcloud.conf
  echo "</VirtualHost>" >> /etc/apache2/sites-available/nextcloud.conf
  a2dissite nextcloud.conf
  a2ensite nextcloud.conf
fi

if [ "$glpi_choice" = "" ] || [ "$glpi_choice" = "Y" ] || [ "$glpi_choice" = "y" ]
then
  mysql -e "DROP DATABASE IF EXISTS glpi;"
  mysql -e "DROP USER IF EXISTS 'glpi'@'localhost';"
  mysql -e "CREATE DATABASE glpi /*\!40100 DEFAULT CHARACTER SET utf8 */;"
  mysql -e "CREATE USER glpi@localhost IDENTIFIED BY 'Not24get@IIA';"
  mysql -e "GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
  rm -r /var/www/glpi
  mkdir /var/www/glpi
  wget https://github.com/glpi-project/glpi/releases/download/10.0.7/glpi-10.0.7.tgz -P /var/www/glpi
  tar -xvf /var/www/glpi/*.tgz -C /var/www/glpi
  rm -r /var/www/glpi/*.tgz
  mv /var/www/glpi/glpi/* /var/www/glpi
  rm -r /var/www/glpi/glpi
  chown -R www-data:www-data /var/www/glpi
  rm -r /etc/apache2/sites-available/glpi.conf
  touch /etc/apache2/sites-available/glpi.conf
  echo "<VirtualHost *:80>" > /etc/apache2/sites-available/glpi.conf
  echo "	DocumentRoot /var/www/glpi" >> /etc/apache2/sites-available/glpi.conf
  echo "	ServerName $website_url" >> /etc/apache2/sites-available/glpi.conf
  echo "" >> /etc/apache2/sites-available/glpi.conf
  echo '	ErrorLog ${APACHE_LOG_DIR}/glpi_error.log' >> /etc/apache2/sites-available/glpi.conf
  echo '	CustomLog ${APACHE_LOG_DIR}/glpi_access.log combined' >> /etc/apache2/sites-available/glpi.conf
  echo "</VirtualHost>" >> /etc/apache2/sites-available/glpi.conf
  a2dissite glpi.conf
  a2ensite glpi.conf
fi

if [ "$dbaccount_choice" = "" ] || [ "$dbaccount_choice" = "Y" ] || [ "$dbaccount_choice" = "y" ]
then
  mysql -e "CREATE USER $dbaccount_name@localhost IDENTIFIED BY 'Not24get@IIA';"
  mysql -e "GRANT ALL PRIVILEGES ON $database_name.* TO '$dbaccount_name'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
fi

if [ "$servertokens_choice" = "" ] || [ "$servertokens_choice" = "Y" ] || [ "$servertokens_choice" = "y" ]
then
  sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-enabled/security.conf
fi

if [ "$https_choice" = "" ] || [ "$https_choice" = "Y" ] || [ "$https_choice" = "y" ]
then
  sudo certbot --apache -d $website_url --post-hook "/usr/sbin/service apache2 restart"
fi

if [ "$apache2_choice" = "" ] || [ "$apache2_choice" = "Y" ] || [ "$apache2_choice" = "y" ]
then
  systemctl restart apache2
fi
echo "----------------"
echo "END OF SCRIPT"
echo "----------------"
if [ "$wordpress_choice" = "" ] || [ "$wordpress_choice" = "Y" ] || [ "$wordpress_choice" = "y" ]
then
  echo "> wordpress user : wordpress"
  echo "> wordpress database : wordpress"
  echo "> wordpress password : Not24get@IIA"
  echo "> wordpress path : /var/www/wordpress"
fi
if [ "$nextcloud_choice" = "" ] || [ "$nextcloud_choice" = "Y" ] || [ "$nextcloud_choice" = "y" ]
then
  echo "> nextcloud user : nextcloud"
  echo "> nextcloud database : nextcloud"
  echo "> nextcloud password : Not24get@IIA"
  echo "> nextcloud path : /var/www/nextcloud"
fi
if [ "$glpi_choice" = "" ] || [ "$glpi_choice" = "Y" ] || [ "$glpi_choice" = "y" ]
then
  echo "> glpi user : glpi"
  echo "> glpi database : glpi"
  echo "> glpi password : Not24get@IIA"
  echo "> glpi path : /var/www/glpi"
fi
echo "----------------"
echo "> password set for all actions : Not24get@IIA"
echo "----------------"
