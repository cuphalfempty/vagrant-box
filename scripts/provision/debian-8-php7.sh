#!/bin/bash

# mysql
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server-5.5 mysql-client-5.5
sudo service mysql start
mysql -uroot -proot -e "create database if not exists app_db"
mysql -uvagrant -pvagrant app_db -e "show tables" &> /dev/null \
	|| mysql -uroot -proot -e "grant all on app_db.* to vagrant@localhost identified by 'vagrant'"
echo -e "[client]\nuser=root\npassword=root\n" > /home/vagrant/.my.cnf

# postgresql
sudo apt-get install -y postgresql-9.4 postgresql-client-9.4
sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant';"
sudo -u postgres createdb -O vagrant app_db

# php
grep -e packages\.dotdeb\.org /etc/apt/sources.list > /dev/null \
       || sudo sh -c "echo '\n\n# php7\ndeb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list" \
       && wget --quiet https://www.dotdeb.org/dotdeb.gpg \
       && sudo apt-key add dotdeb.gpg \
       && sudo apt-get update
sudo apt-get install -y php7.0-cli php7.0-mysql php7.0-pgsql php7.0-curl
# php for Drupal 8
sudo apt-get install -y php7.0-apcu php7.0-gd php7.0-mbstring php7.0-xml php7.0-zip \
       && sudo phpenmod apcu dom gd mbstring simplexml xml zip
grep apc.rfc1867 /etc/php/7.0/apache2/php.ini &> /dev/null \
	|| sudo sh -c "echo '\n;APC configuration\napc.rfc1867 = 1' >> /etc/php/7.0/apache2/php.ini"

# apache
sudo apt-get install -y apache2 libapache2-mod-php7.0
sudo a2enmod rewrite
sudo cp /vagrant/files/etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/
sudo a2ensite 000-default
sudo service apache2 restart
