class raspberrypi {
  file { '/etc/localtime':
    ensure => link,
    target => '../usr/share/zoneinfo/America/Los_Angeles',
  }

  cron { pl2303module:
    command => "(lsmod | grep usbserial  > /dev/null || (echo Adding usbserial module; insmod /usr/lib/modules/`uname -r`/kernel/drivers/usb/serial/usbserial.ko.gz)); (lsmod | grep pl2303 > /dev/null || (echo Adding pl2303 module; insmod /usr/lib/modules/`uname -r`/kernel/drivers/usb/serial/pl2303.ko.gz))",
    minute => '*/10',
  }
}
