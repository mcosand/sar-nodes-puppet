class kcsara::vpn_client ($host = "vpn.example.com", $port = 1194, $out_interface = "eth0" ){
  package { 'openvpn':
    ensure => present,
    before => File['/etc/openvpn/client.conf'],
  }

  file { '/etc/systemd/system/vpnclient.service':
    ensure => file,
    source => "puppet:///modules/kcsara/etc.systemd.system.vpnclient.service",
    before => Service['vpnclient']
  }

  file { '/etc/modules-load.d/tun.conf':
    ensure => file,
    content  => "tun",
  }

  file { '/etc/openvpn/client.conf':
    ensure => file,
    mode => 600,
    content => template('kcsara/etc.openvpn.client.conf.erb'),
  }

  exec { 'loadModule':
    command => "/usr/bin/insmod /usr/lib/modules/`uname -r`/kernel/drivers/net/tun.ko.gz",
    unless => "/usr/bin/lsmod | /usr/bin/grep ^tun",
  }

  file { '/etc/sysctl.d/41-ipv6-eth0.conf':
    ensure => file,
    mode => 644,
    content => "net.ipv6.conf.eth0.disable_ipv6=1",
    before => Service['vpnclient'],
  }

  exec { 'disable-ipv6-eth0':
    command => "/usr/bin/sysctl -w net.ipv6.conf.${$out_interface}.disable_ipv6=1",
    before => Service['vpnclient'],
  }

  service { 'vpnclient':
    ensure => running,
    enable => true,
  }
}
