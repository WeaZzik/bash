echo -n "Password for configuration ? : "
read -s password
echo -n "Domain Name ? (Enter IP if no domain) : "
read -s domain
yes | sudo apt-get purge 'php*'
yes | apt install ca-certificates apt-transport-https software-properties-common curl lsb-release
yes | curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
yes | apt-get update
yes | apt install php8.1 php8.1-ldap libapache2-mod-php8.1 php8.1-fpm php8.1-cli php8.1-common php8.1-bz2 php8.1-curl php8.1-bcmath php8.1-intl php8.1-mbstring php8.1-xmlrpc php8.1-mcrypt php8.1-mysql php8.1-gd php8.1-xml php8.1-zip php8.1-mysqli
yes | apt install mariadb-server
echo -e "\n&\nn\ny\n$password\n$password\ny\ny\ny\ny\n" | mysql_secure_installation
  yes | apt install zip apache2 python3-certbot-apache certbot
  a2enmod rewrite
  a2enmod env
  a2enmod dir
  a2enmod mime
  a2enmod headers
  touch /etc/apache2/sites-available/localhost.conf
  echo "<VirtualHost *:80>" > /etc/apache2/sites-available/localhost.conf
  echo "	DocumentRoot /var/www/html" >> /etc/apache2/sites-available/localhost.conf
  echo "	ServerName $domain" >> /etc/apache2/sites-available/localhost.conf
  echo "" >> /etc/apache2/sites-available/localhost.conf
  echo '	ErrorLog ${APACHE_LOG_DIR}/html_error.log' >> /etc/apache2/sites-available/localhost.conf
  echo '	CustomLog ${APACHE_LOG_DIR}/html_access.log combined' >> /etc/apache2/sites-available/localhost.conf
  echo "</VirtualHost>" >> /etc/apache2/sites-available/localhost.conf
  a2dissite 000-default.conf
  a2ensite localhost.conf
  mysql -e "DROP DATABASE IF EXISTS wordpress;"
  mysql -e "DROP USER IF EXISTS 'wordpress'@'localhost';"
  mysql -e "CREATE DATABASE wordpress /*\!40100 DEFAULT CHARACTER SET utf8 */;"
  mysql -e "CREATE USER wordpress@localhost IDENTIFIED BY '$password';"
  mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
  rm -r /var/www/html
  mkdir /var/www/html
  wget https://wordpress.org/latest.zip -P /var/www/html
  mv /var/www/html/wordpress/* /var/www/html
  rm -r /var/www/html/latest.zip
  rm -r /var/www/html/wordpress
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
  sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
  sed -i "s/username_here/wordpress/" /var/www/html/wp-config.php
  sed -i "s/password_here/$password/" /var/www/html/wp-config.php
  rm /var/www/html/readme.html
  systemctl restart apache2
