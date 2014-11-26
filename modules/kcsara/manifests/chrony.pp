class kcsara::chrony ($gps_device = hiera('gps_device')) {
  package { ntpd:
    ensure => absent
  }

  package { chrony: 
    require => Package['ntpd'],
  }
 
  file { '/etc/chrony.conf':
    ensure => file,
    mode => 644,
    content => template('kcsara/etc.chrony.conf.erb'),
    require => Package['chrony'],
  }

  service { chrony:
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    subscribe => File['/etc/chrony.conf'],
  }

  if $gps_device {
    include kcsara::gpsd
    Service['gpsd'] ~> Service['chrony']
  }
}
