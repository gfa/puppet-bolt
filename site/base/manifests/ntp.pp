# this class manages ntp
# just remove ntp and enable systemd-timesyncd

class base::ntp {

  package { 'ntp':
    ensure => purged,
  }

  service { 'systemd-timesyncd':
    ensure => running,
    enable => true,
  }

}
