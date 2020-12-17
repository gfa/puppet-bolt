# this class configures the vnstat plugin for munin for all interfaces but lo
#

class profile::monitoring::munin::node::plugin::vnstat {

  $interfaces = $facts['networking']['interfaces'].keys()

  ($interfaces.filter | $interface | { $interface != 'lo' }).each | $iface | {

    munin::plugin { "vnstat_${iface}":
      ensure  => present,
      source  => "puppet:///modules/${module_name}/monitoring/munin/node/plugins/vnstat_",
      require => Package['vnstat'],
    }

  }
}
