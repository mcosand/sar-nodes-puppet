class raspberrypi::watchdog {
  include raspberrypi

  ## Watchdog timer
  package { 'watchdog':
    ensure => present,
  }
  file { '/etc/modules-load.d/bcm2708_wdog.conf':
    ensure => file,
    content => 'bcm2708_wdog',
    mode => 644,
  }

  file { '/etc/watchdog.d':
    ensure => directory,
    mode => 755,
  }

  exec { '/usr/bin/modprobe bcm2708_wdog':
    unless => '/usr/bin/lsmod | /usr/bin/grep bcm2708_wdog',
  }

  file { '/etc/watchdog.conf':
    ensure => file,
    mode => 644,
    source => "puppet:///modules/raspberrypi/watchdog.conf",
    require => Package['watchdog'],
  }

  service { 'watchdog':
    enable => true,
    ensure => running,
    require => [File['/etc/watchdog.conf'], Exec['/usr/bin/modprobe bcm2708_wdog']],
    subscribe => File['/etc/watchdog.conf'],
  }
}
