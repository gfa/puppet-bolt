# this class manages munin plugins for prosody
#

class profile::monitoring::munin::node::prosody {

  include profile::monitoring::munin::node

  profile::monitoring::munin::node::conf { 'prosody':
    source => "puppet:///modules/${module_name}/monitoring/munin/node/prosody_munin.conf"
  }

  profile::monitoring::munin::node::check { 'ps_prosody':
    script => 'ps_'
  }

  $plugins_to_install = ['prosody_users', 'prosody_c2s']

  $plugins_to_install.each |$index, $plugin| {
    file { "/usr/share/munin/plugins/${plugin}":
      ensure => file,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/${module_name}/monitoring/munin/node/plugins/${plugin}"
    }

    profile::monitoring::munin::node::check { $plugin:
      script => $plugin
    }

  }

  $prosody_c2s_plugins = [ 'prosody_uptime', 'prosody_presence', 'prosody_s2s']

  $prosody_c2s_plugins.each |$index2, $plugin2| {
    profile::monitoring::munin::node::check { $plugin2:
      script => 'prosody_c2s'
    }
  }

}
