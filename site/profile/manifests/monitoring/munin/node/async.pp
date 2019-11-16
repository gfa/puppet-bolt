# This class manages munin-async
#
# @param ssh_keys contains the ssh keys to inject for the munin-async user
#

class profile::monitoring::munin::node::async (
  Hash $ssh_keys
) {

  package {'munin-async':
    ensure => installed,
  }

  -> user { 'munin-async':
    ensure         => present,
    purge_ssh_keys => true,
    home           => '/var/lib/munin-async',
  }

  $ssh_keys.each |$key, $data| {
    ssh_authorized_key { "${key}-munin-async":
      ensure  => present,
      type    => $data['type'],
      options => $data['options'],
      key     => $data['key'],
      user    => 'munin-async',
      require => User['munin-async'],
    }
  }

  service { 'munin-async':
    ensure => running,
    enable => true,
  }

}
