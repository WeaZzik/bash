#!/bin/bash
yes | apt-get update
yes | apt install ca-certificates apt-transport-https software-properties-common curl lsb-release
yes | curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
yes | apt-get update
yes | apt install php8.1 libapache2-mod-php8.1 php8.1-fpm php8.1-cli php8.1-common php8.1-curl php8.1-bcmath php8.1-intl php8.1-mbstring php8.1-xmlrpc php8.1-mcrypt php8.1-mysql php8.1-gd php8.1-xml php8.1-cli php8.1-zip php8.1-mysqli
yes | apt install mariadb-server zip apache2
echo "& n y Not24get@IIA Not24get@IIA y y y y" | mysql_secure_installation
mkdir /var/www/temp
touch /var/www/index.php
echo "<?php" > /var/www/index.php
echo "phpinfo()" > /var/www/index.php
echo "?>" > /var/www/index.php

echo "END OF SCRIPT"