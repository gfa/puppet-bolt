# this class manages vnstat
#


class profile::monitoring::vnstat {

  include systemd::systemctl::daemon_reload

  file { '/etc/systemd/system/vnstat.service.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/systemd/system/vnstat.service.d/vnstat.conf':
    ensure => absent,
    force  => true,
  }

  file { '/etc/systemd/system/vnstat.service.d/vnstat2.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => "[Service]\nExecStart=\nExecStart=/usr/sbin/vnstatd -n --alwaysadd\n",
  }

  ~> Class['systemd::systemctl::daemon_reload']

  service {'vnstat':
    ensure    => 'running',
    subscribe => File['/etc/systemd/system/vnstat.service.d/vnstat2.conf'],
  }

}
