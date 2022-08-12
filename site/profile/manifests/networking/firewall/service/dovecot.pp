# this class manages the fw for dovecot
#
#
class profile::networking::firewall::service::dovecot {

  firewall { '300 accept imaps':
    chain    => 'INPUT',
    dport    => 993,
    proto    => 'tcp',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
  }

}
