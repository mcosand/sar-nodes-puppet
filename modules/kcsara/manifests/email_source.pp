class kcsara::email_source ($email = '', $password = '', $server = '', $admin_addr = '') {
  include kcsara

  package {'postfix':
  }

  file {'/etc/mailname':
    content => "$::fqdn",
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  file {'/etc/aliases':
    ensure => file,
    content => template('kcsara/etc.aliases.erb'),
    mode => 644,
    require => Package['postfix'],
  }

  exec {'/usr/bin/newaliases':
    command => '/usr/bin/newaliases && chown postfix /etc/aliases.db',
    subscribe => File['/etc/aliases'],
    refreshonly => true,
    notify => Service['postfix'],
  }
     
  file {'/etc/postfix/canonical':
    ensure => file,
    content => template('kcsara/etc.postfix.canonical.erb'),
    mode => 644,
    require => Package['postfix'],
  }

  exec {'/usr/bin/postmap hash:/etc/postfix/canonical':
    subscribe => File['/etc/postfix/canonical'],
    refreshonly => true,
    notify => Service['postfix'],
  }

  file {'/etc/postfix/header_checks':
    ensure => file,
    content => template('kcsara/etc.postfix.header_checks.erb'),
    mode => 644,
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  file {'/etc/postfix/smtp_auth':
    ensure => file,
    content => "[$server]:587	$email:$password\n",
    mode => 600,
    require => Package['postfix'],
  }

  exec {'/usr/bin/postmap hash:/etc/postfix/smtp_auth':
    subscribe => File['/etc/postfix/smtp_auth'],
    refreshonly => true,
    notify => Service['postfix'],
  }

  file {'/etc/postfix/main.cf':
    ensure => file,
    content => template('kcsara/etc.postfix.main.cf.erb'),
    mode => 644,
    require => Package['postfix'],
    notify => Service['postfix'],
  }

 service {'postfix':
    ensure => running,
    enable => true,
    require => Package['postfix']
  }
}
