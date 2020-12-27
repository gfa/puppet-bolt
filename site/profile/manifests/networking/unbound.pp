# this class manages unbound
#

class profile::networking::unbound {

  package { 'unbound': }

  service { 'unbound':
    ensure  => running,
    enable  => true,
    require => Package['unbound'],
  }

  file { '/etc/unbound/unbound.conf.d/local.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/etc/unbound/unbound.conf.d/local.conf",
    require => Package['unbound'],
    notify  => Service['unbound'],
  }

  firewall_multi { '300 outgoing unbound':
    dport    => 53,
    proto    => ['udp', 'tcp'],
    action   => 'accept',
    chain    => 'OUTPUT',
    provider => ['iptables', 'ip6tables'],
    uid      => 'unbound',
    require  => Package['unbound'],
  }

}
