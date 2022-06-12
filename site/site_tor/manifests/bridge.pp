# this class configures a tor bridge
#
#
class site_tor::bridge {

  package { ['tor', 'obfs4proxy']: }

  $bridge_port1 = 1024 + fqdn_rand(64511, 'port 1')
  $bridge_port2 = 1024 + fqdn_rand(64511, 'port 2')
  $bridge_nickname = seeded_rand_string(8, '', 'abcdefghijklmnopqrstuvwxyz')

  service { 'tor':
    ensure  => running,
    enable  => true,
    require => Package['tor'],
  }

  file { '/etc/tor/torrc':
    ensure  => file,
    notify  => Service['tor'],
    require => Package['tor'],
    content => template("${module_name}/etc/tor/torrc.bridge.erb"),
  }

  firewall_multi { '300 incoming tor':
    chain    => 'INPUT',
    dport    => [$bridge_port1, $bridge_port2],
    proto    => 'tcp',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
  }

  firewall_multi { '300 outgoing tor':
    chain    => 'OUTPUT',
    proto    => 'tcp',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
    require  => Package['tor'],
    uid      => 'debian-tor',
  }

}
