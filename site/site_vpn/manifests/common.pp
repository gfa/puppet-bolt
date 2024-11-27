# this class manages the common bits of vpn config
#
class site_vpn::common {

  include site_vpn::resolver

  class { 'wireguard': }

  firewall_multi { '100 accept outgoing wg':
    proto      => 'udp',
    chain      => 'OUTPUT',
    action     => 'accept',
    provider   => ['iptables', 'ip6tables'],
    match_mark => lookup('wireguard::firewall_mark', Integer[0, 4294967295], undef, 1),
  }

  firewall_multi { '100 accept incoming vpn0':
    proto    => 'all',
    chain    => 'INPUT',
    action   => 'accept',
    iniface  => 'vpn0',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '100 accept outgoing vpn0':
    proto    => 'all',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
    outiface => 'vpn0',
  }

  if lookup('wireguard::provider', Enum['systemd', 'wgquick'], undef, 'wgquick') == 'wgquick' {
    service { 'wg-quick@vpn0':
      ensure  => 'running',
      enable  => true,
      require => Package['wireguard-tools'],
    }
  }
}
