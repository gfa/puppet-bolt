# handles the firewall for dn42 hosts
# for now only wireguard interfaces are managed


class profile::networking::dn42::firewall {

  firewall_multi { '001 do not track wg traffic in':
    provider => ['iptables', 'ip6tables'],
    table    => 'raw',
    chain    => 'PREROUTING',
    jump     => 'NOTRACK',
    iniface  => 'wg+',
  }

  firewall_multi { '001 do not track wg traffic out':
    provider => ['iptables', 'ip6tables'],
    table    => 'raw',
    chain    => 'OUTPUT',
    jump     => 'NOTRACK',
    outiface => 'wg+',
  }

  firewall_multi { '100 allow incoming traffic on wg+':
    provider => ['iptables', 'ip6tables'],
    chain    => 'INPUT',
    iniface  => 'wg+',
    action   => 'accept',
    proto    => 'all',
  }

  firewall_multi { '100 allow outgoing traffic on wg+':
    provider => ['iptables', 'ip6tables'],
    chain    => 'OUTPUT',
    outiface => 'wg+',
    action   => 'accept',
    proto    => 'all',
  }

}
