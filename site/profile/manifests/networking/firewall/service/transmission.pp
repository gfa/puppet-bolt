# this class manages the firewall for transmission
#
# @param blocklist_url url where to download blocklists
# @param peer_port_random_low low port if using random ports
# @param peer_port_random_high high port if using random ports
# @param peer_port port to use if using static ports
# @param peer_port_random if use random ports
# @param rpc_port port used for rpc
#

class profile::networking::firewall::service::transmission (
  Stdlib::HTTPUrl $blocklist_url = lookup('transmission::blocklist_url'),
  Optional[Stdlib::Port] $peer_port_random_low = lookup('transmission::peer_port_random_low'),
  Optional[Stdlib::Port] $peer_port_random_high = lookup('transmission::peer_port_random_high'),
  $peer_port = lookup('transmission::peer_port', Optional[Stdlib::Port], undef, undef),
  Boolean $peer_port_random = lookup('transmission::peer_port_random_on_start'),
  Stdlib::Port $rpc_port = lookup('transmission::rpc_port'),
) {

  if $peer_port_random {
    firewall_multi { '300 accept transmission incoming':
      chain    => 'INPUT',
      dport    => join([$peer_port_random_low, '-', $peer_port_random_high], ''),
      proto    => ['tcp', 'udp'],
      action   => 'accept',
      provider => ['iptables', 'ip6tables'],
      require  => Class['profile::networking::firewall::base'],
    }
  } else {
    firewall_multi { '300 accept transmission incoming':
      chain    => 'INPUT',
      dport    => $peer_port,
      proto    => ['tcp', 'udp'],
      action   => 'accept',
      provider => ['iptables', 'ip6tables'],
      require  => Class['profile::networking::firewall::base'],
    }
  }

  if $blocklist_url != 'http://www.example.com/blocklist' {

    # TODO: only allow connections to the FQDN of the blocklist
    firewall_multi { '300 accept transmission blocklists':
      chain    => 'OUTPUT',
      dport    => [80, 443],
      proto    => 'tcp',
      action   => 'accept',
      provider => ['iptables', 'ip6tables'],
      require  => Package['transmission-daemon'],
      uid      => 'debian-transmission',
      before   => Exec['transmission_download_blocklists'],
    }
  }

  firewall_multi { '300 accept transmission outgoing':
    chain    => 'OUTPUT',
    proto    => ['tcp', 'udp'],
    dport    => '1024-65535',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
    require  => Package['transmission-daemon'],
    uid      => 'debian-transmission',
  }

  firewall { '301 accept transmission rpc4':
    chain    => 'INPUT',
    proto    => 'tcp',
    dport    => $rpc_port,
    action   => 'accept',
    provider => 'iptables',
    ipset    => 'myhosts4 src',
    require  => Class['profile::networking::firewall::base'],
  }

  firewall { '301 accept transmission rpc6':
    chain    => 'INPUT',
    dport    => $rpc_port,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
    ipset    => 'myhosts6 src',
    require  => Class['profile::networking::firewall::base'],
  }

}
