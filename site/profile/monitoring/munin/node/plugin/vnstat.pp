# this class configures the vnstat plugin for munin
#

class profile::monitoring::munin::node::plugin::vnstat {

  munin::plugin { "vnstat_${facts['networking']['primary']}":
    ensure  => present,
    source  => "puppet:///modules/${module_name}/monitoring/munin/node/plugins/vnstat_",
    require => Package['vnstat'],
  }

}
