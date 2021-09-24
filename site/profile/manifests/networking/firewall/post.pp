# Rules added at the end of the iptables chains
#

class profile::networking::firewall::post {

  firewallchain { 'INPUT:filter:IPv6':
    ensure => present,
    policy => drop,
    before => undef,
  }

  firewallchain { 'INPUT:filter:IPv4':
    ensure => present,
    policy => drop,
    before => undef,
  }

  firewallchain { 'FORWARD:filter:IPv6':
    ensure => present,
    policy => drop,
    before => undef,
  }

  firewallchain { 'FORWARD:filter:IPv4':
    ensure => present,
    policy => drop,
    before => undef,
  }

  firewallchain { 'OUTPUT:filter:IPv6':
    ensure  => present,
    policy  => drop,
    before  => undef,
    require => Service['dnsmasq'],
  }

  firewallchain { 'OUTPUT:filter:IPv4':
    ensure => present,
    policy => drop,
    before => undef,
  }

}
