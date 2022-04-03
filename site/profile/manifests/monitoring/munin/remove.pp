# this class removes munin-node and friends
#
#
class profile::monitoring::munin::remove {

  package { ['munin-node', 'munin-async', 'munin-plugins-core']:
    ensure => purged,
  }

  user { 'munin-async':
    ensure         => absent,
  }

  file { '/etc/munin/plugins':
    ensure  => absent,
    recurse => true,
    purge   => true,
    force   => true,
  }

}
