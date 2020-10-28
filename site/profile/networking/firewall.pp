# This is the base class to manage a firewall using puppet
#

class profile::networking::firewall {

  class { 'firewall': }

  resources { 'firewall':
    purge => true,
  }

  resources { 'firewallchain':
    purge => false,
  }

  firewallchain {
    [
      'INPUT:filter:IPv4',
      'FORWARD:filter:IPv4',
      'OUTPUT:filter:IPv4',
      'PREROUTING:mangle:IPv4',
      'INPUT:mangle:IPv4',
      'FORWARD:mangle:IPv4',
      'OUTPUT:mangle:IPv4',
      'POSTROUTING:mangle:IPv4',
      'PREROUTING:nat:IPv4',
      'INPUT:nat:IPv4',
      'OUTPUT:nat:IPv4',
      'POSTROUTING:nat:IPv4',
      'PREROUTING:raw:IPv4',
      'OUTPUT:raw:IPv4',
      'INPUT:filter:IPv6',
      'FORWARD:filter:IPv6',
      'OUTPUT:filter:IPv6',
      'PREROUTING:mangle:IPv6',
      'INPUT:mangle:IPv6',
      'FORWARD:mangle:IPv6',
      'OUTPUT:mangle:IPv6',
      'POSTROUTING:mangle:IPv6',
      'PREROUTING:nat:IPv6',
      'INPUT:nat:IPv6',
      'OUTPUT:nat:IPv6',
      'POSTROUTING:nat:IPv6',
      'PREROUTING:raw:IPv6',
      'OUTPUT:raw:IPv6',
      'FILTERS:filter:IPv6',
      'FILTERS:filter:IPv4',
    ]:
      purge =>  true,
  }

  Firewall {
    before  => Class['profile::networking::firewall::post'],
    require => Class['profile::networking::firewall::pre'],
  }

  class { ['profile::networking::firewall::pre', 'profile::networking::firewall::post' ]: }

  contain profile::networking::firewall::common
  contain profile::networking::firewall::base
  contain profile::networking::firewall::fail2ban

}
