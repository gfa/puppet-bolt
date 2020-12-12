# this class wraps the bird module
#

class site_bird (
  Integer $as,
  Stdlib::IP::Address::V4::CIDR $ipv4_range,
  Stdlib::IP::Address::V6::CIDR $ipv6_range,
  Stdlib::IP::Address::V4::Nosubnet $ipv4_own,
  Stdlib::IP::Address::V6::Nosubnet $ipv6_own,
) {

  include profile::monitoring::munin::node::plugin::bird

  $directories = [
    '/etc/bird',
    '/etc/bird/peers4',
    '/etc/bird/peers6',
  ]

  $directories.each | String $directory | {
    file { $directory:
      ensure  => directory,
    }
  }

  $files = [
    '/etc/bird/local6.conf',
    '/etc/bird/local4.conf',
  ]

  $files.each | String $file | {
    file { $file:
      owner   => 'root',
      group   => 'bird',
      mode    => '0640',
      content => template("${module_name}/${file}.erb"),
    }
  }

  class { 'bird':
    enable_v6         => true,
    config_content_v4 => template("${module_name}/etc/bird/bird.conf.erb"),
    config_content_v6 => template("${module_name}/etc/bird/bird6.conf.erb"),
    manage_conf       => true,
    manage_service    => true,
    service_v4_ensure => running,
    service_v6_ensure => running,
    service_v4_enable => true,
    service_v6_enable => true,
  }

  firewall_multi { '300 allow incoming bgp traffic':
    provider => ['iptables', 'ip6tables'],
    chain    => 'INPUT',
    dport    => 179,
    action   => 'accept',
    iniface  => 'wg+',
  }

  firewall_multi { '300 allow outgoing bird traffic':
    provider => ['iptables', 'ip6tables'],
    chain    => 'OUTPUT',
    dport    => '179',
    action   => 'accept',
    uid      => 'bird',
    outiface => 'wg+',
  }

}
