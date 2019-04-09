# this class configures plugins for munin
#

class site_munin::node::plugins {

  munin::plugin { "vnstat_${facts['interfaces'][0]}":
    ensure  => present,
    source  => "puppet:///modules/${module_name}/plugins/vnstat_",
    require => Package['vnstat'],
  }

}
