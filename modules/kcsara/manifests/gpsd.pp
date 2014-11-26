class kcsara::gpsd ($gps_device = hiera('gps_device')) {
  include systemctl

  package { gpsd:
    before => Exec['systemctl-reload'],
  }

  file { '/etc/systemd/system/gpsd.service.d/override.conf':
    ensure => file,
    mode => 644,
    content => template('kcsara/gpsd.service.override.erb'),
    require => Package['gpsd'],
    notify => Exec['systemctl-reload']
  }

  service { gpsd:
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => Exec['systemctl-reload'],
    subscribe => File['/etc/systemd/system/gpsd.service.d/override.conf'],
  }
}
