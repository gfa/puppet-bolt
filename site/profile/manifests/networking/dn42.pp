# this profile applies to servers part of the dn42 network
#

class profile::networking::dn42 {

  include site_bird
  include profile::networking::dn42::firewall

  sysctl { 'net.ipv4.ip_forward':
    ensure => present,
    value  => '1',
  }

  sysctl { 'net.ipv6.conf.default.forwarding':
    ensure => present,
    value  => "1",
  }

  sysctl { 'net.ipv6.conf.all.forwarding':
    ensure => present,
    value  => '1',
  }

  # if problems arise, change to 2
  sysctl { 'net.ipv4.conf.default.rp_filter':
    ensure => present,
    value  => '0',
  }

  sysctl { 'net.ipv4.conf.all.rp_filter':
    ensure => present,
    value  => '0',
  }

  sysctl { 'net.ipv4.conf.all.log_martians':
    ensure => present,
    value  => '1',
  }

  sysctl {'net.ipv4.conf.default.log_martians':
    ensure => present,
    value => '1',
  }

}
