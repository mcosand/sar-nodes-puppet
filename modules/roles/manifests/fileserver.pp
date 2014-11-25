class roles::fileserver {
  package { samba:
    ensure => installed,
  }

  service { smbd:
    ensure => running,
    enable => true,
    require => Package['samba'],
  }

  service { nmbd:
    ensure => running,
    enable => true,
    require => Package['samba'],
  }

  file { '/etc/samba/smb.conf':
    ensure => file,
    content => template("roles/smb.conf.erb"),
    require => Package['samba'],
    notify => Service['smbd'],
  }

#  class {'samba::server':
#    workgroup => 'kcsara',
#    server_string => 'KCSARA File Server',
#    security => 'user',
#    encrypt_passwords => true,
#    map_to_guest => 'Bad User',
#    writeable => 'yes',
#  }

  file { '/srv/samba':
    ensure => directory,
    mode => 644,
  }

  file { '/srv/samba/share':
    ensure => directory,
    mode => 666,
    require => File['/srv/samba'],
  }

#  samba::server::share { 'share':
#    comment => 'General file storage',
#    path => '/srv/samba/share',
#    guest_only => true,
#    guest_ok => true,
#    read_only => false,
#    browsable => true,
#    create_mask => 0700,
#    directory_mask => 0700,
#  }

  file { '/srv/samba/database':
    ensure => directory,
    mode => 666,
#    before => Samba::Server::Share['database'],
    require => File['/srv/samba'],
  }

#  samba::server::share { 'database':
#    comment => 'Submit files to KCSARA database',
#    path => '/srv/samba/database',
#    guest_only => true,
#    guest_ok => true,
#    read_only => false,
#    browsable => true,
#    create_mask => 0700,
#    directory_mask => 0700,
#  }

  file { '/srv/samba/reference':
    ensure => directory,
    mode => 666,
#    before => Samba::Server::Share['reference'],
    require => File['/srv/samba'],
  }

#  samba::server::share { 'reference':
#    comment => 'Reference information',
#    path => '/srv/samba/reference',
#    guest_only => true,
#    guest_ok => true,
#    read_only => true,
#    browsable => true,
#    create_mask => 0700,
#    directory_mask => 0700,
#  }
}
