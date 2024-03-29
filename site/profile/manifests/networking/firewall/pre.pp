# This firewall rules are added before any user-defined rule
#

class profile::networking::firewall::pre {

  # moved this here since the default is to use iptables-nft
  # but due to docker we need to use iptables-legacy.
  # If this is done outside this class, it breaks the initial
  # deploy of the machine since some objects which are depended on
  # are created but then they magically disapear after the change of
  # iptables implementation
  # f**k docker
  # double f**k docker as i'm switching away to podman in bullseye
  case $facts['os']['distro']['codename'] {
    'buster': {
      alternatives { 'iptables':
        path =>  '/usr/sbin/iptables-legacy',
      }

      alternatives { 'ip6tables':
        path =>  '/usr/sbin/ip6tables-legacy',
      }
    }
    'bullseye', 'bookworm', 'bookworm/sid', 'sid', 'jammy': {
      alternatives { 'iptables':
        path =>  '/usr/sbin/iptables-nft',
      }

      alternatives { 'ip6tables':
        path =>  '/usr/sbin/ip6tables-nft',
      }

    }
    default: {
      fail('which distro is this?')
    }
  }

  reboot { 'reboot after iptables alternatives changed':
    subscribe => [
      Alternatives['iptables'],
      Alternatives['ip6tables'],
    ]
  }


  Firewall { require => undef, }

  # INPUT
  firewall_multi { '003 allow input related and established':
    chain    => 'INPUT',
    state    => ['RELATED', 'ESTABLISHED'],
    proto    => 'all',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '001 allow input lo':
    chain    => 'INPUT',
    proto    => 'all',
    action   => 'accept',
    iniface  => 'lo',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '100 allow input ssh':
    chain    => 'INPUT',
    proto    => 'tcp',
    dport    => [22, 9022],
    state    => 'NEW',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '101 allow input icmp':
    chain    => 'INPUT',
    proto    => 'icmp',
    icmp     => [0, 3, 8, 11, 42],
    action   => 'accept',
    provider => ['iptables'],
  }

  firewall_multi { '101 allow input icmp echo from subnet':
    chain    => 'INPUT',
    proto    => 'ipv6-icmp',
    icmp     => [130, 131, 132, 133, 135, 137, 143, 151, 152, 153],
    source   => 'fe80::/10',
    action   => 'accept',
    provider => ['ip6tables'],
  }

  firewall_multi { '102 allow input icmp':
    chain    => 'INPUT',
    proto    => 'ipv6-icmp',
    icmp     => [1, 2, 3, 4, 128, 133, 134, 135, 136, 137, 141, 142, 148, 149],
    action   => 'accept',
    provider => ['ip6tables'],
  }

  firewall_multi { '003 allow output related and established':
    chain    => 'OUTPUT',
    state    => ['RELATED', 'ESTABLISHED'],
    proto    => 'all',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '001 allow output lo':
    chain    => 'OUTPUT',
    proto    => 'all',
    action   => 'accept',
    outiface => 'lo',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '004 allow output for root':
    chain    => 'OUTPUT',
    proto    => 'all',
    uid      => 'root',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '005 allow output icmp echo':
    chain    => 'OUTPUT',
    proto    => 'icmp',
    icmp     => [0, 8],
    action   => 'accept',
    provider => ['iptables'],
  }

  firewall_multi { '006 Allow OUTPUT dnsmasq':
    chain    => 'OUTPUT',
    state    => 'NEW',
    proto    => ['tcp', 'udp'],
    dport    => 53,
    uid      => 'dnsmasq',
    require  => Package['dnsmasq'],
    provider => [ 'iptables', 'ip6tables'],
    action   => 'accept',
  }

  firewall_multi { '102 allow output icmp':
    chain    => 'OUTPUT',
    proto    => 'ipv6-icmp',
    icmp     => [3, 128, 135, 136, 137],
    action   => 'accept',
    provider => ['ip6tables'],
  }

  firewall_multi { '101 allow output icmp to site-local and multicast':
    chain       => 'OUTPUT',
    proto       => 'ipv6-icmp',
    icmp        => [131, 132, 133, 135, 137, 143],
    destination => ['fc00::/7', 'ff00::/8'],
    source      => 'fe80::/10',
    action      => 'accept',
    provider    => ['ip6tables'],
  }

}
