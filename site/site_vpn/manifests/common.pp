# this class manages the common bits of vpn config
#
class site_vpn::common {

  class { 'wireguard': }

  firewall_multi { '100 accept incoming wg':
    dport    => lookup('wireguard::port'),
    proto    => 'udp',
    chain    => 'INPUT',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '100 accept outgoing wg':
    sport      => lookup('wireguard::port'),
    proto      => 'udp',
    chain      => 'OUTPUT',
    action     => 'accept',
    provider   => ['iptables', 'ip6tables'],
    match_mark => lookup('wireguard::firewall_mark', Integer[0, 4294967295], undef, 1),
  }


}
