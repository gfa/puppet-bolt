# this class manages ntp
# just remove ntp and enable systemd-timesyncd
#
class profile::networking::service::ntp::client {

  package { 'ntp':
    ensure => purged,
  }

  if 'openntpd' in $facts['dpkgs'] {
    service { 'systemd-timesyncd':
      ensure => stopped,
      enable => false,
    }
  } else {

    package { 'systemd-timesyncd': }

    service { 'systemd-timesyncd':
      ensure => running,
      enable => true,
    }

    firewall_multi { '200 accept output ntp':
      dport    => '123',
      proto    => 'udp',
      chain    => 'OUTPUT',
      action   => 'accept',
      provider => ['iptables', 'ip6tables'],
      uid      => systemd-timesync,
    }
  }
}
