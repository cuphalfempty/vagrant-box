exec { "apt-get update":
  path => "/usr/bin",
}
package { "postgresql-9.5":
  ensure => present,
  require => Exec["apt-get update"],
}
package { "postgresql-client-9.5":
  ensure => present,
  require => Exec["apt-get update"],
}
service { "postgresql":
  ensure => running,
  require => Package["postgresql-9.5"],
}
package { "apache2":
  ensure => present,
  require => Exec["apt-get update"],
}
service { "apache2":
  ensure => running,
  require => Package["apache2"],
}
