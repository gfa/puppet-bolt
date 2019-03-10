# this class manages resolv.conf
#

class base::resolvconf {

  if $facts['dmi']['bios']['vendor'] == 'Google' {
    package { 'resolvconf':
      ensure => present,
    }
  }

  class { 'resolv_conf':
    nameservers => ['127.0.0.1'],
    searchpath  => [''],
    require     => Package['dnsmasq'],
  }

}
