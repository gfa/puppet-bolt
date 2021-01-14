# this class manages all common munin plugins

class profile::monitoring::munin::node::plugins {

  include profile::monitoring::munin::node::plugin::vnstat
  include profile::monitoring::munin::node::plugin::ipset
  include profile::monitoring::munin::node::plugin::systemd

  $obsolete_checks = [
    "bandwidth_${facts['networking']['primary']}",
    "ip_${facts['networking']['ip']}",
    "ip_${facts['networking']['ip6']}",
    'postfix_mailvolume',
    'sshguard',
    'traffic',
  ]

  $obsolete_checks.each |Integer $index, String $check| {

    file { "/etc/munin/plugins/${check}":
      ensure => absent,
      notify => Service['munin-node'],
    }
  }

  $links = [
    'fw_conntrack',
    'fw_forwarded_local',
    'fw_packets',
  ]

  $links.each |$index, $link| {

    munin::plugin { $link:
      ensure => link,
      notify => Service['munin-node', 'munin-async'],
    }
  }

}
