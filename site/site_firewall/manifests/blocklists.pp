# this class manages blocklists
# IPs on the blocklist(s) are not allowed
# to contact us, neither we are allow to
# contact them

class site_firewall::blocklists {

  file { '/etc/cron.hourly/update-ipsets-blocklist.de':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${module_name}/update-ipsets-blocklist.de",
  }

  firewall { '002 block botnets input ip4':
    chain    => 'INPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'iptables',
    ipset    => 'block4 src',
  }

  firewall { '002 block botnets input ip6':
    chain    => 'INPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    ipset    => 'block6 src',
  }

  firewall { '002 block botnets output ip4':
    chain    => 'OUTPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'iptables',
    ipset    => 'block4 dst',
  }

  firewall { '002 block botnets output ip6':
    chain    => 'OUTPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    ipset    => 'block6 dst',
  }

}
