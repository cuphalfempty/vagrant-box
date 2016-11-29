class mysql {
  package { "mysql-server-5.5":
    ensure => present,
  }
  package { "mysql-client-5.5":
    ensure => present,
  }
  service { "mysql":
    ensure => running,
    require => Package["mysql-server-5.5"],
  }
  exec { "set-mysql-password":
    unless => "mysql -uroot -proot",
    path => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password root",
    require => Service["mysql"],
  }
  file { 'user/.my.cnf':
    ensure => present,
    content => "[client]\nuser=root\npassword=root\n",
    path => '/home/vagrant/.my.cnf',
    require => Package['mysql-server-5.5'],
    mode => 0644,
    owner => 'vagrant',
    group => 'vagrant',
  }
}

class php {
  package { "php5":
    ensure => present,
  }
  package { "php5-cli":
    ensure => present,
  }
  package { "php5-mysql":
    ensure => present,
    require => Package["mysql-server-5.5", "php5"],
  }
}

class apache {
  package { "apache2":
    ensure => present,
  }
  package { "libapache2-mod-php5":
    ensure => present,
    require => Package["apache2"],
  }
  service { "apache2":
    ensure => running,
    require => Package["apache2"],
  }
  exec { "apache-en-rewrite":
    path => ["/bin", "/usr/bin"],
    command => "sudo a2enmod rewrite",
    require => Service["apache2"],
  }
  file { 'html/index.php':
    ensure => present,
    content => "<?php\nphpinfo();\n",
    path => '/var/www/html/index.php',
    require => Package['apache2'],
    mode => 0644,
    owner => 'www-data',
    group => 'www-data',
  }
}

class tools {
  package { "vim":
    ensure => present,
  }
}

include mysql
include php
include apache
include tools
