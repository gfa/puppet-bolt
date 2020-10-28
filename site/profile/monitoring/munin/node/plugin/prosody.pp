# this class manages munin plugins for prosody
#

class profile::monitoring::munin::node::plugin::prosody {

  include profile::monitoring::munin::node

  profile::monitoring::munin::node::conf { 'prosody':
    source => "puppet:///modules/${module_name}/monitoring/munin/node/prosody_munin.conf",
  }

  file { '/etc/munin/plugins/ps_prosody':
    ensure => absent,
  }

  file { '/etc/munin/plugins/prosody_presence':
    ensure => absent,
  }

  file { '/usr/share/munin/plugins/prosody_':
    ensure => file,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${module_name}/monitoring/munin/node/plugins/prosody_",
  }

  $prosody_plugins = ['prosody_users', 'prosody_c2s', 'prosody_uptime', 'prosody_s2s' ]

  $prosody_plugins.each |$index, $plugin| {
    profile::monitoring::munin::node::check { $plugin:
      script => 'prosody_',
    }
  }

}
