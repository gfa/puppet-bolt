# This firewall rules are added before any user-defined rule
#

class site_firewall::pre {

  Firewall { require => undef, }

  if $facts['ipaddress_eth0'] {
    firewall { '001 munin monitoring input ipv4':
      chain       => 'INPUT',
      proto       => 'all',
      destination => $facts['ipaddress_eth0'],
    }
  }

  firewall { '100 Allow OUTPUT for root':
    chain  => 'OUTPUT',
    proto  => 'all',
    uid    => 'root',
    action => 'accept',
  }

  firewall { '090 Allow INPUT SSH':
    chain  => 'INPUT',
    proto  => 'tcp',
    port   => '22',
    state  => 'NEW',
    action => 'accept',
  }

  firewall { '100 Allow INPUT RELATED and ESTABLISHED':
    chain  => 'INPUT',
    state  => ['RELATED', 'ESTABLISHED'],
    proto  => 'all',
    action => 'accept';
  }

  firewall { '100 Allow OUTPUT RELATED and ESTABLISHED':
    chain  => 'OUTPUT',
    state  => ['RELATED', 'ESTABLISHED'],
    proto  => 'all',
    action => 'accept';
  }

  firewall { '101 Allow OUTPUT ICMP echo':
    chain  => 'OUTPUT',
    state  => 'NEW',
    proto  => 'icmp',
    icmp   => 'echo-request',
    action => 'accept';
  }

  firewall { '101 Allow INPUT ICMP echo':
    chain  => 'INPUT',
    state  => 'NEW',
    proto  => 'icmp',
    icmp   => 'echo-request',
    action => 'accept';
  }

  site_firewall::accept_output { 'DHCP client':
    proto => 'udp',
    dport => [67, 68],
  }

  site_firewall::accept_output { 'loopback':
    proto    => 'all',
    outiface => 'lo',
  }

  site_firewall::accept_input { 'loopback':
    proto   => 'all',
    iniface => 'lo',
  }

  site_firewall::accept_output { 'DNS/UDP':
    proto => 'udp',
    dport => 53,
  }

}
