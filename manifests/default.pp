class mysql {
  package { "mysql-server-5.7":
    ensure => present,
  }
  package { "mysql-client-5.7":
    ensure => present,
  }
  service { "mysql":
    ensure => running,
    require => Package["mysql-server-5.7"],
  }
  exec { "set-mysql-password":
    unless => "mysql -uroot -proot",
    path => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password root",
    require => Service["mysql"],
  }
  exec { "create-mysql-database":
    unless => "/usr/bin/mysql -umy_user -pmy_user my_db",
    command => "/usr/bin/mysql -uroot -proot -e \"create database my_db; grant all on my_db.* to my_user@'%' identified by 'my_user';\"",
    require => Service["mysql"],
  }
}

class php {
  package { "php7.0":
    ensure => present,
  }
  package { "php7.0-cli":
    ensure => present,
  }
  package { "php7.0-mysql":
    ensure => present,
    require => Package["mysql-server-5.7", "php7.0"],
  }
}

class apache {
  package { "apache2":
    ensure => present,
  }
  package { "libapache2-mod-php7.0":
    ensure => present,
    require => Package["apache2"],
  }
  service { "apache2":
    ensure => running,
    require => Package["apache2"],
  }
}

include mysql
include apache
include php
