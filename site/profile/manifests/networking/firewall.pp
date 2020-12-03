# This is the base class to manage a firewall using puppet
#

class profile::networking::firewall (
  Boolean $purge_rules = true,
  Boolean $purge_chains = true,
) {

  class { 'firewall': }

  resources { 'firewall':
    purge => $purge_rules,
  }

  resources { 'firewallchain':
    purge => $purge_chains,
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
