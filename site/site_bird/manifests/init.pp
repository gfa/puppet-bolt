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
    '/etc/bird/peers',
  ]

  $directories.each | String $directory | {
    file { $directory:
      ensure  => directory,
    }
  }

  package { 'bird2': }

  service { 'bird':
    ensure  => running,
    enable  => true,
    require => Package['bird2'],
  }

  file { [
    '/var/log/bird.log',
    '/var/log/bird-remote.log',
    '/var/log/bird-local.log',
    '/var/log/bird-all.log',
  ]:
    owner   => 'bird',
    group   => 'bird',
    mode    => '0644',
    require => Package['bird2'],
    replace => 'no',
    content => '',
  }

  file { '/etc/bird/bird.conf':
    owner   => 'root',
    group   => 'bird',
    mode    => '0640',
    content => template("${module_name}/etc/bird/bird.conf.erb"),
    notify  => Service['bird'],
    require => Package['bird2'],
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
