# this class configures the ipset plugin for munin
#

class profile::monitoring::munin::node::plugin::ipset {

  munin::plugin { 'ipset':
    ensure => present,
    source => "puppet:///modules/${module_name}/monitoring/munin/node/plugins/ipset",
    config  => ['user root'],
  }

}
