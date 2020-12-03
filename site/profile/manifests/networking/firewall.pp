# This is the base class to manage a firewall using puppet
#

class profile::networking::firewall {

  class { 'firewall': }

  resources { 'firewall':
    # take this value from hiera, default: true
    # to solve docker problem
    purge => true,
  }

  resources { 'firewallchain':
    # take this value from hiera, default: true
    purge => true,
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
