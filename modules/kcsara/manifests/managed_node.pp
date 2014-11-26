class kcsara::managed_node ($gps_device = hiera('gps_device')) {
  include kcsaracheckin
  include kcsara::email_source
  include kcsara::vpn_client
  include kcsara::chrony

  if $gps_device {
    include kcsara::gpsd
    include kcsara::gpslogger
  }

  cron { puppet:
    command => "/usr/bin/ps aux | /usr/bin/grep puppet | grep -v grep > /dev/null || (/usr/bin/nice /usr/bin/puppet agent --test > /dev/null ; /usr/bin/touch /root/last_puppet_run)",
    minute => '14',
  }
}
