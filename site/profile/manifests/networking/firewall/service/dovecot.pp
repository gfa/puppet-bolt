# this class manages the fw for dovecot
#

class profile::networking::firewall::service::dovecot {

  firewall { '300 accept hosts dovecot clients4':
    chain    => 'INPUT',
    dport    => [143, 993, 4190],
    proto    => 'tcp',
    action   => 'accept',
    provider => 'iptables',
    ipset    => 'myhosts4 src',
  }

  firewall { '300 accept hosts dovecot clients6':
    chain    => 'INPUT',
    dport    => [143, 993, 4190],
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
    ipset    => 'myhosts6 src',
  }

  firewall { '300 accept countries dovecot clients4':
    chain    => 'INPUT',
    dport    => [143, 993, 4190],
    proto    => 'tcp',
    action   => 'accept',
    provider => 'iptables',
    ipset    => 'countries-allow4 src',
  }

  firewall { '300 accept countries dovecot clients6':
    chain    => 'INPUT',
    dport    => [143, 993, 4190],
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
    ipset    => 'countries-allow6 src',
  }

}
