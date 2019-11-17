# this class manages resolv.conf
#

class profile::networking::service::resolvconf {

  package { 'resolvconf':
    ensure => present,
  }

  file { '/etc/resolv.conf':
    ensure  => link,
    target  => '/etc/resolvconf/run/resolv.conf',
    require => Package['dnsmasq', 'resolvconf'],
  }

}