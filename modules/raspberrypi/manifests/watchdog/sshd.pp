class raspberrypi::watchdog::sshd {
  include raspberrypi::watchdog

  ## Can ssh into self to test ssh sever
  user { 'ssh-test':
    ensure => present,
  }

  file { ['/home/ssh-test', '/home/ssh-test/.ssh']:
    ensure => directory,
    owner => 'ssh-test',
    group => 'ssh-test',
    mode => 700,
    require => User['ssh-test'],
  }

  exec { 'create-ssh-key':
    command => "/usr/bin/su ssh-test -c\"/usr/bin/ssh-keygen -t rsa -b 2048 -q -N '' -f /home/ssh-test/.ssh/id_rsa\"",
    unless => '/usr/bin/ls /home/ssh-test/.ssh/id_rsa',
    require => File['/home/ssh-test/.ssh'],
  }

  exec { 'authorize-ssh-key':
    command => '/usr/bin/cp /home/ssh-test/.ssh/id_rsa.pub /home/ssh-test/.ssh/authorized_keys',
    require => Exec['create-ssh-key'],
    refreshonly => true,
    subscribe => Exec['create-ssh-key'],
  }

  file { '/etc/ssh/ssh_host_ecdsa_key.pub':
    ensure => present,
  }

  exec { 'localhost-is-known':
    command => '/usr/bin/echo 127.0.0.1 `/usr/bin/cat /etc/ssh/ssh_host_ecdsa_key.pub | sed -e "s/ [^ ]*$//"` >> /home/ssh-test/.ssh/known_hosts',
    unless => '/usr/bin/grep 127.0.0.1 /home/ssh-test/.ssh/known_hosts',
    require => [File['/etc/ssh/ssh_host_ecdsa_key.pub'], File['/home/ssh-test/.ssh']],
  }

  file { '/etc/watchdog.d/ssh-working.sh':
    ensure => file,
    mode => 755,
    source => "puppet:///modules/raspberrypi/watchdog-scripts/ssh-working.sh",
    require => File['/etc/watchdog.d'],
    notify => Service['watchdog'],
  }

}
