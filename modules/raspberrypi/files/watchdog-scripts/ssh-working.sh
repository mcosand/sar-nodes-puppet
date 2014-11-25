#!/bin/sh

# If the service isn't enabled don't check it.
(/usr/bin/systemctl is-enabled sshd.service > /dev/null) || (/usr/bin/echo SSHD not running ; exit 0)

# Try to login to the local server
(/usr/bin/ssh -o ConnectTimeout=2 root@127.0.0.1 /usr/bin/true) || exit -2
