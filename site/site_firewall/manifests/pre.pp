# This firewall rules are added before any user-defined rule
#

class site_firewall::pre {

  Firewall { require => undef, }

  # INPUT
  firewall_multi { '001 Allow INPUT RELATED and ESTABLISHED':
    chain    => 'INPUT',
    state    => ['RELATED', 'ESTABLISHED'],
    proto    => 'all',
    action   => 'accept',
    provider => [ 'iptables', 'ip6tables'],
  }

  firewall_multi { '002 Allow INPUT lo':
    chain    => 'INPUT',
    proto    => 'all',
    action   => 'accept',
    iniface  => 'lo',
    provider => [ 'iptables', 'ip6tables'],
  }

  firewallchain { 'FILTER:filter:IPv4':
    ensure  => present,
  }

  firewallchain { 'FILTER:filter:IPv6':
    ensure  => present,
  }

  firewall_multi { '099 fail2ban':
    chain    => 'INPUT',
    proto    => 'all',
    jump     => 'FILTER',
    provider => [ 'iptables', 'ip6tables'],
  }

  firewall_multi { '100 Allow INPUT SSH':
    chain    => 'INPUT',
    proto    => 'tcp',
    dport    => '22',
    state    => 'NEW',
    action   => 'accept',
    provider => [ 'iptables', 'ip6tables'],
  }

  firewall { '101 Allow INPUT ICMP echo':
    chain  => 'INPUT',
    state  => 'NEW',
    proto  => 'icmp',
    icmp   => 'echo-request',
    action => 'accept',
  }

  site_firewall::accept_output { 'DHCP client':
    proto => 'udp',
    dport => [67, 68],
  }

  #  site_firewall::accept_output { 'DNS/UDP':
  #  proto => 'udp',
  #  dport => 53,
  # }

  # OUTPUT
  firewall_multi { '001 Allow OUTPUT RELATED and ESTABLISHED':
    chain    => 'OUTPUT',
    state    => ['RELATED', 'ESTABLISHED'],
    proto    => 'all',
    action   => 'accept',
    provider => [ 'iptables', 'ip6tables'],
  }

  firewall_multi { '002 Allow OUTPUT lo':
    chain    => 'OUTPUT',
    proto    => 'all',
    action   => 'accept',
    outiface => 'lo',
    provider => [ 'iptables', 'ip6tables'],
  }

  firewall_multi { '003 Allow OUTPUT for root':
    chain    => 'OUTPUT',
    proto    => 'all',
    uid      => 'root',
    action   => 'accept',
    provider => [ 'iptables', 'ip6tables'],
  }

  firewall { '004 Allow OUTPUT ICMP echo':
    chain  => 'OUTPUT',
    state  => 'NEW',
    proto  => 'icmp',
    icmp   => 'echo-request',
    action => 'accept',
  }

  firewall_multi { '005 Allow OUTPUT dnsmasq':
    chain    => 'OUTPUT',
    state    => 'NEW',
    proto    => ['tcp', 'udp'],
    dport    => 53,
    uid      => 'dnsmasq',
    require  => Package['dnsmasq'],
    provider => [ 'iptables', 'ip6tables'],
    action   => 'accept',
  }

}
