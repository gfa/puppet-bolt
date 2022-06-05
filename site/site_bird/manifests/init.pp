# this class wraps the bird module
#
# @param as
# @param ipv4_own
# @param ipv4_range
# @param ipv6_own
# @param ipv6_range
# @param dn42_region
# @param prometheus_host4
# @param prometheus_host6
#
class site_bird (
  Integer $as,
  Integer $dn42_region,
  Stdlib::IP::Address::V4::CIDR $ipv4_range,
  Stdlib::IP::Address::V6::CIDR $ipv6_range,
  Stdlib::IP::Address::V4::Nosubnet $ipv4_own,
  Stdlib::IP::Address::V6::Nosubnet $ipv6_own,
  Array[Stdlib::Host] $prometheus_host4 = lookup('profile::monitoring::prometheus::node_exporter::prometheus_hosts4'),
  Array[Stdlib::Host] $prometheus_host6 = lookup('profile::monitoring::prometheus::node_exporter::prometheus_hosts6'),
) {

  file {
    '/etc/bird':
      ensure => directory,
      ;
    '/etc/bird/peers':
      ensure => directory,
      purge  => true;
  }

  package { 'bird2':
    ensure => latest,
  }

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

  file { '/etc/logrotate.d/bird':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/etc/logrotate.d/bird",
  }

  cron { 'logrotate':
    command     => '/usr/bin/chronic logrotate /etc/logrotate.conf',
    user        => 'root',
    hour        => '*/2',
    minute      => 10,
    environment => 'PATH=/bin:/usr/bin:/usr/sbin:/sbin',
  }

  file { '/etc/bird/bird.conf':
    owner   => 'root',
    group   => 'bird',
    mode    => '0640',
    content => template("${module_name}/etc/bird/bird.conf.erb"),
    notify  => Service['bird'],
    require => Package['bird2'],
  }

  file { '/etc/bird/community_filters.conf':
    owner   => 'root',
    group   => 'bird',
    mode    => '0640',
    content => epp("${module_name}/etc/bird/community_filters.conf.epp"),
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

  exec { 'birdc configure':
    command     => 'birdc configure',
    refreshonly => true,
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', ],
  }

  package { 'prometheus-bird-exporter': }

  firewall_multi { '400 incoming bird exporter ipv4':
    chain    => 'INPUT',
    dport    => 9200,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'iptables',
    source   => $prometheus_host4,
  }

  firewall_multi { '400 incoming bird exporter ipv6':
    chain    => 'INPUT',
    dport    => 9200,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
    source   => $prometheus_host6,
  }


}
