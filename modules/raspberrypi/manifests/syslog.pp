class raspberrypi::syslog {
  package { 'syslog-ng': }

  service { 'syslog-ng':
    enable => true,
    hasstatus => true,
    subscribe => File['/etc/syslog-ng/syslog-ng.conf'],
  }

  file { '/etc/syslog-ng/syslog-ng.conf':
    ensure => file,
    source => 'puppet:///modules/raspberrypi/syslog-ng.conf',
    mode => 644,
    require => Package['syslog-ng'],
  }
}
