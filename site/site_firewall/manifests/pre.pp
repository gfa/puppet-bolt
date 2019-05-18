# This firewall rules are added before any user-defined rule
#

class site_firewall::pre {

  # tried many things but either
  # - fail2ban rules are saved to disk
  # - fail2ban breaks because rules/chains are missing
  # sadly, the most reliable thing to do is restart fail2ban
  #
  # fail2ban >=0.10.2 restores the banned hosts after restart :)

  exec { 'stop_fail2ban':
    command => '/usr/sbin/invoke-rc.d fail2ban stop || true',
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

  firewall_multi { '099 fail2ban':
    chain    => 'INPUT',
    proto    => 'all',
    jump     => 'FILTERS',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '100 allow input ssh':
    chain    => 'INPUT',
    proto    => 'tcp',
    dport    => '22',
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
    icmp     => [128, 135, 136, 137],
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

  firewall_multi { '999 log icmp input':
    chain      => 'INPUT',
    proto      => 'ipv6-icmp',
    jump       => 'LOG',
    log_prefix => 'INPUT ',
    provider   => ['ip6tables'],
  }

  firewall_multi { '999 log icmp output':
    chain      => 'OUTPUT',
    proto      => 'ipv6-icmp',
    jump       => 'LOG',
    log_prefix => 'OUTPUT ',
    provider   => ['ip6tables'],
  }

}
