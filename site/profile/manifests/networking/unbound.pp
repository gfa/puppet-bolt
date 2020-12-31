# this class manages unbound
#
# @param access_control
#

class profile::networking::unbound (
  Array[String] $access_control = ['127.0.0.0/8 allow_snoop'],
) {

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
    content => epp("${module_name}/etc/unbound/unbound.conf.d/local.conf.epp"),
    require => Package['unbound'],
    notify  => Service['unbound'],
  }

  file { '/var/log/unbound.log':
    ensure  => file,
    owner   => 'unbound',
    group   => 'unbound',
    mode    => '0644',
    require => Package['unbound'],
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
