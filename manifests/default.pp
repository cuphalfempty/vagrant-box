class mysql {
  exec { "apt-get update":
    path => "/usr/bin",
  }
  package { "mysql-server-5.7":
    ensure => present,
    require => Exec["apt-get update"],
  }
  package { "mysql-client-5.7":
    ensure => present,
    require => Exec["apt-get update"],
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
    unless => "/usr/bin/mysql -uszkodnik -pszkodnik cuphalfe_d7",
    command => "/usr/bin/mysql -uroot -proot -e \"create database cuphalfe_d7; grant all on cuphalfe_d7.* to szkodnik@localhost identified by 'szkodnik';\"",
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
