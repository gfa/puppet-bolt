# Wrapper class to configure unattended upgrades from hiera
#
#
class profile::package::unattended_upgrades {

  class { 'unattended_upgrades':
    * => lookup('unattended_upgrades', Hash, {'strategy' => 'deep', 'merge_hash_arrays' => true}, {}),
  }

  service { 'unattended-upgrades':
    ensure => stopped,
    enable => false,
  }

}
