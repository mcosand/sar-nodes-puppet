class kcsara::gpslogger {
  file { '/root/gps-logger.rb':
    ensure => file,
    mode => 644,
    source => 'puppet:///modules/kcsara/root.gps-logger.rb',
 }

  file { '/etc/systemd/system/gpslogger.service':
    ensure => file,
    mode => 644,
    source => 'puppet:///modules/kcsara/etc.systemd.system.gpslogger.service'
  }

  service { 'gpslogger':
    ensure => running,
    enable => true,
    hasstatus => true,
    subscribe => [
                   File['/root/gps-logger.rb'],
                   File['/etc/systemd/system/gpslogger.service'],
                 ],
  }
}
