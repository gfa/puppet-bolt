# this class configures the timesync plugin for munin
#

class profile::monitoring::munin::node::plugin::timesync_status {

  munin::plugin { 'timesync_status':
    ensure => present,
    source => "puppet:///modules/${module_name}/etc/munin/plugins/timesync_status",
  }

}
