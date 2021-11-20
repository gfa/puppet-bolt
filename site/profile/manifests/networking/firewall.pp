# This is the base class to manage a firewall using puppet
#

class profile::networking::firewall (
  Boolean $purge_rules = true,
  Boolean $purge_chains = true,
  Array[String] $extra_chains = [],
) {

  class { 'firewall': }

  resources { 'firewall':
    purge => $purge_rules,
  }

  resources { 'firewallchain':
    purge => $purge_chains,
  }

  # add them here so puppet doesnt try to remove it
  firewallchain {
    [
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
    ]:
  }

  if $extra_chains {
    $extra_chains.each |String $chain| {
      firewallchain { $chain: }
    }
  }

  Firewall {
    before  => Class['profile::networking::firewall::post'],
    require => Class['profile::networking::firewall::pre'],
  }

  class { ['profile::networking::firewall::pre', 'profile::networking::firewall::post' ]: }

  contain profile::networking::firewall::common
  contain profile::networking::firewall::base
  contain profile::networking::firewall::fail2ban
  contain profile::networking::firewall::blocklists::remove

}
