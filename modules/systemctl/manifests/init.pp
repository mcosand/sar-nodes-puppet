class systemctl
{
  exec {'systemctl-reload':
    command => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }
}
