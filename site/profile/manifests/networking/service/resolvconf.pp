# this class manages resolv.conf
#
#
class profile::networking::service::resolvconf {

  package { 'resolvconf':
    ensure => purged,
  }

  file { '/etc/resolv.conf':
    ensure  => file,
    require => Package['dnsmasq'],
    content => "nameserver 127.0.0.1\n",
  }

}
