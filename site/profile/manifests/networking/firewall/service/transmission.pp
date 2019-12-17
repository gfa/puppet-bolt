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
  Stdlib::HTTPUrl $blocklist_url = $profile::service::transmission::blocklist_url,
  Stdlib::Port $peer_port_random_low = $profile::service::transmission::peer_port_random_low,
  Stdlib::Port $peer_port_random_high = $profile::service::transmission::peer_port_random_high,
  Stdlib::Port $peer_port = $profile::service::transmission::peer_port,
  Boolean $peer_port_random = $profile::service::transmission::peer_port_random,
  Stdlib::Port $rpc_port = $profile::service::transmission::rpc_port,
) {

  if $peer_port_random == true {
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

  firewall { '300 accept transmission rpc4':
    chain    => 'OUTPUT',
    proto    => 'tcp',
    dport    => $rpc_port,
    action   => 'accept',
    provider => 'iptables',
    ipset    => 'myhosts4 src',
    require  => Class['profile::networking::firewall::base'],
  }

  firewall { '300 accept transmission rpc6':
   chain    => 'OUTPUT',
   dport    => $rpc_port,
   proto    => 'tcp',
   action   => 'accept',
   provider => 'ip6tables',
   ipset    => 'myhosts6 src',
   require  => Class['profile::networking::firewall::base'],
  }

}
