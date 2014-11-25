class raspberrypi {
  file { '/etc/localtime':
    ensure => link,
    target => '../usr/share/zoneinfo/America/Los_Angeles',
  }
}
