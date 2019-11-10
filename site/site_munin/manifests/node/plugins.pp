# this class configures plugins for munin
#

class site_munin::node::plugins {

  munin::plugin { "vnstat_${facts['networking']['primary']}":
    ensure  => present,
    source  => "puppet:///modules/${module_name}/plugins/vnstat_",
    require => Package['vnstat'],
  }

  munin::plugin { 'ipset':
    ensure => present,
    source => "puppet:///modules/${module_name}/plugins/ipset",
  }

}
