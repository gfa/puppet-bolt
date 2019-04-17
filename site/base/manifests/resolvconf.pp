# this class manages resolv.conf
#

class base::resolvconf {

  package { 'resolvconf':
    ensure => present,
  }

  class { 'resolv_conf':
    nameservers => ['127.0.0.1'],
    searchpath  => [''],
    require     => Package['dnsmasq'],
  }

  file { '/etc/resolv.conf':
    ensure => link,
    target => '/etc/resolvconf/run/resolv.conf',
  }

}
