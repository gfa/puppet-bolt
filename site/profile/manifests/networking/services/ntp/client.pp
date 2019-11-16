# this class manages ntp
# just remove ntp and enable systemd-timesyncd

class profile::networking::services::ntp::client {

  package { 'ntp':
    ensure => purged,
  }

  service { 'systemd-timesyncd':
    ensure => running,
    enable => true,
  }

}
