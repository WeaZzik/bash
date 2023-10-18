#################### QNA ######################

#!/bin/bash
temp=$(hostname -I)
myip=$(echo "${temp// /}")
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
  echo "add a custom url ? [Y/n] ?"
  read customurl_choice
  if [ "$customurl_choice" = "" ] || [ "$customurl_choice" = "Y" ] || [ "$customurl_choice" = "y" ]
  then
    echo "enter custom url (ex: temp.fr) :"
    read custom_url
  fi
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
  yes | sudo apt-get purge 'php*'
  yes | apt install ca-certificates apt-transport-https software-properties-common curl lsb-release
  yes | curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
  yes | apt-get update
yes | apt install php8.1 libapache2-mod-php8.1 php8.1-fpm php8.1-cli php8.1-common php8.1-bz2 php8.1-curl php8.1-bcmath php8.1-intl php8.1-mbstring php8.1-xmlrpc php8.1-mcrypt php8.1-mysql php8.1-gd php8.1-xml php8.1-cli php8.1-zip php8.1-mysqli
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
  rm -r /etc/apache2/sites-available/localhost.conf
  touch /etc/apache2/sites-available/localhost.conf
  echo "<VirtualHost *:80>" > /etc/apache2/sites-available/localhost.conf
  echo "	DocumentRoot /var/www/html" >> /etc/apache2/sites-available/localhost.conf
  if [ "$customurl_choice" = "" ] || [ "$customurl_choice" = "Y" ] || [ "$customurl_choice" = "y" ]
  then
    echo "	ServerName $customurl" >> /etc/apache2/sites-available/localhost.conf
  else
    echo "	ServerName $myip" >> /etc/apache2/sites-available/localhost.conf
  fi
  echo "" >> /etc/apache2/sites-available/localhost.conf
  echo '	ErrorLog ${APACHE_LOG_DIR}/html_error.log' >> /etc/apache2/sites-available/localhost.conf
  echo '	CustomLog ${APACHE_LOG_DIR}/html_access.log combined' >> /etc/apache2/sites-available/localhost.conf
  if [ "$wordpress_choice" = "" ] || [ "$wordpress_choice" = "Y" ] || [ "$wordpress_choice" = "y" ]
  then
    echo '	Alias /wordpress  /var/www/html/wordpress' >> /etc/apache2/sites-available/localhost.conf
  fi
  if [ "$nextcloud_choice" = "" ] || [ "$nextcloud_choice" = "Y" ] || [ "$nextcloud_choice" = "y" ]
  then
    echo '	Alias /nextcloud  /var/www/html/nextcloud' >> /etc/apache2/sites-available/localhost.conf
  fi
  then
    echo '	Alias /glpi  /var/www/html/glpi' >> /etc/apache2/sites-available/localhost.conf
  fi
  echo "</VirtualHost>" >> /etc/apache2/sites-available/localhost.conf
  a2dissite 000-default.conf
  a2ensite localhost.conf
fi

if [ "$wordpress_choice" = "" ] || [ "$wordpress_choice" = "Y" ] || [ "$wordpress_choice" = "y" ]
then
  mysql -e "DROP DATABASE IF EXISTS wordpress;"
  mysql -e "DROP USER IF EXISTS 'wordpress'@'localhost';"
  mysql -e "CREATE DATABASE wordpress /*\!40100 DEFAULT CHARACTER SET utf8 */;"
  mysql -e "CREATE USER wordpress@localhost IDENTIFIED BY 'Not24get@IIA';"
  mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
  rm -r /var/www/html/wordpress
  mkdir /var/www/html/wordpress
  wget https://wordpress.org/latest.zip -P /var/www/html/wordpress
  unzip /var/www/html/wordpress/latest.zip -d /var/www/html/wordpress
  mv /var/www/html/wordpress/wordpress/* /var/www/html/wordpress
  rm -r /var/www/html/wordpress/latest.zip
  rm -r /var/www/html/wordpress/wordpress
  chown -R www-data:www-data /var/www/html/wordpress
  cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
  sed -i 's/database_name_here/wordpress/' /var/www/html/wordpress/wp-config.php
  sed -i 's/username_here/wordpress/' /var/www/html/wordpress/wp-config.php
  sed -i 's/password_here/Not24get@IIA/' /var/www/html/wordpress/wp-config.php
  rm /var/www/html/wordpress/readme.html
fi
if [ "$nextcloud_choice" = "" ] || [ "$nextcloud_choice" = "Y" ] || [ "$nextcloud_choice" = "y" ]
then
  mysql -e "DROP DATABASE IF EXISTS nextcloud;"
  mysql -e "DROP USER IF EXISTS 'nextcloud'@'localhost';"
  mysql -e "CREATE DATABASE nextcloud /*\!40100 DEFAULT CHARACTER SET utf8 */;"
  mysql -e "CREATE USER nextcloud@localhost IDENTIFIED BY 'Not24get@IIA';"
  mysql -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
  rm -r /var/www/html/nextcloud
  mkdir /var/www/html/nextcloud
  wget https://download.nextcloud.com/server/releases/latest.zip -P /var/www/html/nextcloud
  unzip /var/www/html/nextcloud/latest.zip -d /var/www/html/nextcloud
  mv /var/www/html/nextcloud/nextcloud/* /var/www/html/nextcloud
  rm -r /var/www/html/nextcloud/latest.zip
  rm -r /var/www/html/nextcloud/nextcloud
  chown -R www-data:www-data /var/www/html/nextcloud
  cd /var/www/html/nextcloud
  sudo -u www-data php occ  maintenance:install --database \
"mysql" --database-name "nextcloud"  --database-user "nextcloud" --database-pass \
"Not24get@IIA" --admin-user "nextcloud" --admin-pass "Not24get@IIA"
  cd ~
  sed -ie "/^0/a 1 => 'localhost/nextcloud'" /var/www/html/nextcloud/config/config.php
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
  wget https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz -P /var/www/glpi
  tar -xvf /var/www/glpi/*.tgz -C /var/www/glpi
  rm -r /var/www/glpi/*.tgz
  mv /var/www/glpi/glpi/* /var/www/glpi
  rm -r /var/www/glpi/glpi
  chown -R www-data:www-data /var/www/glpi
  mkdir /var/log/glpi
  mkdir /var/lib/glpi
  mkdir /etc/glpi
  chown -R www-data:www-data /var/lib/glpi
  chown -R www-data:www-data /var/log/glpi
  chown -R www-data:www-data /etc/glpi
  mv -f /var/www/glpi/config /etc/glpi/
  mv -f /var/www/glpi/files /var/lib/glpi/
  touch /var/www/glpi/inc/downstream.php
  echo "<?php" >> /var/www/glpi/inc/downstream.php
  echo "define('GLPI_CONFIG_DIR', '/etc/glpi/');" >> /var/www/glpi/inc/downstream.php
  echo "" >> /var/www/glpi/inc/downstream.php
  echo "if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')){" >> /var/www/glpi/inc/downstream.php
  echo "	require_once GLPI_CONFIG_DIR . '/local_define.php';" >> /var/www/glpi/inc/downstream.php
  echo "}" >> /var/www/glpi/inc/downstream.php
  touch /var/www/glpi/inc/downstream.php
  echo "<?php" >> /etc/glpi/local_define.php
  echo "define('GLPI_VAR_DIR', '/var/lib/glpi/');" >> /etc/glpi/local_define.php
  echo "define('GLPI_LOG_DIR', '/var/log/glpi/');" >> /etc/glpi/local_define.php
  rm -r /var/www/glpi/install
fi

if [ "$servertokens_choice" = "" ] || [ "$servertokens_choice" = "Y" ] || [ "$servertokens_choice" = "y" ]
then
  sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-enabled/security.conf
fi
echo "----------------"
echo "END OF SCRIPT"
echo "----------------"
if [ "$wordpress_choice" = "" ] || [ "$wordpress_choice" = "Y" ] || [ "$wordpress_choice" = "y" ]
then
  echo "> wordpress user : wordpress"
  echo "> wordpress database : wordpress"
  echo "> wordpress password : Not24get@IIA"
  echo "> wordpress path : /var/www/html/wordpress"
  if [ "$customurl_choice" = "" ] || [ "$customurl_choice" = "Y" ] || [ "$customurl_choice" = "y" ]
  then
    echo "> wordpress URL : http://$customurl/wordpress"
  else
    echo "> wordpress URL : http://$customurl/wordpress"
  fi
fi
if [ "$nextcloud_choice" = "" ] || [ "$nextcloud_choice" = "Y" ] || [ "$nextcloud_choice" = "y" ]
then
  echo "> nextcloud user : nextcloud"
  echo "> nextcloud database : nextcloud"
  echo "> nextcloud password : Not24get@IIA"
  echo "> nextcloud path : /var/www/html/nextcloud"
  if [ "$customurl_choice" = "" ] || [ "$customurl_choice" = "Y" ] || [ "$customurl_choice" = "y" ]
  then
    echo "> wordpress URL : http://$customurl/nextcloud"
  else
    echo "> wordpress URL : http://$customurl/nextcloud"
  fi
fi
if [ "$glpi_choice" = "" ] || [ "$glpi_choice" = "Y" ] || [ "$glpi_choice" = "y" ]
then
  echo "> glpi user : glpi"
  echo "> glpi database : glpi"
  echo "> glpi password : Not24get@IIA"
  echo "> glpi path : /var/www/html/glpi"
  if [ "$customurl_choice" = "" ] || [ "$customurl_choice" = "Y" ] || [ "$customurl_choice" = "y" ]
  then
    echo "> wordpress URL : http://$customurl/glpi"
  else
    echo "> wordpress URL : http://$customurl/glpi"
  fi
fi
echo "----------------"
echo "> password set for all actions : Not24get@IIA"
echo "----------------"
