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
sudo apt-get install -y php5 php5-cli php5-mysql php5-pgsql php5-curl php5-gd php5-apcu
sudo php5enmod apcu gd
grep apc.rfc1867 /etc/php5/apache2/php.ini &> /dev/null \
	|| sudo sh -c "echo -e '\n;APC configuration\napc.rfc1867 = 1' >> /etc/php5/apache2/php.ini"

# apache
sudo apt-get install -y apache2 libapache2-mod-php5
sudo a2enmod rewrite
sudo cp /vagrant/files/etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/
sudo a2ensite 000-default
sudo service apache2 restart
