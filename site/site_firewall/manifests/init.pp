# This is the base class to manage a firewall using puppet
#

class site_firewall {

  class { 'firewall': }

  # do not purge other firewall rules
  # or fail2ban breaks
  resources { 'firewall':
    purge => false,
  }

  resources { 'firewallchain':
    purge => false,
  }

  # but purge the default tables
  # https://tickets.puppetlabs.com/browse/MODULES-2314
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
    ]:
      purge => true,
  }

  # ignore fail2ban and sshguard rules
  Firewallchain <| title == 'INPUT:filter:IPv4' |> {
    ignore +> [
      '-j f2b-ssh',
      '-j fail2ban-ssh',
      '-j f2b-[\w]+',
      '-j fail2ban-[\w]+',
      '-j sshguard',
    ]
  }

  Firewallchain <| title == 'INPUT:filter:IPv6' |> {
    ignore +> [
      '-j f2b-ssh',
      '-j fail2ban-ssh',
      '-j f2b-[\w]+',
      '-j fail2ban-[\w]+',
      '-j sshguard',
    ]
  }

  Firewall {
    before  => Class['site_firewall::post'],
    require => Class['site_firewall::pre'],
  }

  class { ['site_firewall::pre', 'site_firewall::post' ]: }

  contain site_firewall::common

}
