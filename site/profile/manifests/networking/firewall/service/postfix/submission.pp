# this class manages the fw for postfix
#

class profile::networking::firewall::service::postfix::submission {

  firewall { '300 accept hosts postfix submission4':
    chain    => 'INPUT',
    dport    => 587,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'iptables',
    ipset    => 'myhosts4 src',
  }

  firewall { '300 accept hosts postfix submission6':
    chain    => 'INPUT',
    dport    => 587,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
    ipset    => 'myhosts6 src',
  }

  firewall { '300 accept countries postfix submission4':
    chain    => 'INPUT',
    dport    => 587,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'iptables',
    ipset    => 'countries-allow4 src',
  }

  firewall { '300 accept countries postfix submission6':
    chain    => 'INPUT',
    dport    => 587,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
    ipset    => 'countries-allow6 src',
  }

}
