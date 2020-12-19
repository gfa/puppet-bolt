# this class configures the bird plugin for munin
#

class profile::monitoring::munin::node::plugin::bird {

  munin::plugin { 'bird':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/etc/munin/plugins/bird",
    config  => ['env.protocols BGP', 'user bird', 'group bird', 'env.socket /run/bird/bird.ctl'],
    require => Package['bird2'],
  }

  munin::plugin { 'bird6':
    ensure  => absent,
  }

}
