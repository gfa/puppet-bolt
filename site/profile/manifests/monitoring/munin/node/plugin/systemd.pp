# this class configures the systemd plugin for munin
#

class profile::monitoring::munin::node::plugin::systemd {

  munin::plugin { 'timesync_status':
    ensure => present,
    source => "puppet:///modules/${module_name}/etc/munin/plugins/timesync_status",
  }

  munin::plugin { 'systemd_status':
    ensure => present,
    source => "puppet:///modules/${module_name}/etc/munin/plugins/systemd_status",
  }

  munin::plugin { 'systemd_units':
    ensure => present,
    source => "puppet:///modules/${module_name}/etc/munin/plugins/systemd_units",
  }

}
