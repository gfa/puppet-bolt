# this class manages ntp
# just remove ntp and enable systemd-timesyncd

class profile::networking::service::ntp::client {

  package { 'ntp':
    ensure => purged,
  }

  service { 'systemd-timesyncd':
    ensure => running,
    enable => true,
  }

}
