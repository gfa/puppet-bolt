# this profile applies to servers part of the dn42 network
#

class profile::networking::dn42 {

  include site_bird
  include site_bird::peerings
  include profile::networking::dn42::firewall
  include profile::networking::dn42::wireguard
  include profile::networking::unbound::dn42

  sysctl { 'net.ipv4.ip_forward':
    ensure => present,
    value  => '1',
  }

  sysctl { 'net.ipv6.conf.default.forwarding':
    ensure => present,
    value  => '1',
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
    value  => '1',
  }

  package { [
      'mtr-tiny',
      'vim-nox',
      'tcpdump',
      'tshark',
      'ethtool', #  ethtool -K eth0 tx off rx off
      'curl',
      'fping',
      'hping3',
      'ipcalc',
      'sipcalc',
  ]: }

  $roa_files = [
    '/etc/bird/roa_dn42.conf',
    '/etc/bird/roa_dn42_v6.conf',
  ]

  $roa_files.each | String $file | {
    file { $file:
      owner   => 'root',
      mode    => '0644',
      group   => 'bird',
      require => Package['bird2'],
      content => '#',
      replace => no,
    }
  }

  file { '/etc/cron.d/dn42_roa':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/etc/cron.d/dn42_roa.epp"),
    require => [Package['bird2'], Package['curl']],
  }

  file { '/usr/local/bin/bgp-community.rb':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/usr/local/bin/bgp-community.rb",
  }

  file_line { 'Append dn42 roa files to /etc/.gitignore':
    path    => '/etc/.gitignore',
    line    => "bird/roa_dn42.conf\n",
    match   => '^bird\/roa_dn42.conf$',
    require => Package['etckeeper'],
  }

  file_line { 'Append dn42 roa v6 files to /etc/.gitignore':
    path    => '/etc/.gitignore',
    line    => "bird/roa_dn42_v6.conf\n",
    match   => '^bird\/roa_dn42_v6.conf$',
    require => Package['etckeeper'],
  }

  apt::key { 'mine':
    id     => '27263FA42553615F904A7EBE2A40A2ECB8DAD8D5',
    server => 'subkeys.pgp.net',
  }

  apt::source { 'personal_backports':
    location => 'https://zumbi.com.ar/buster-bpo/',
    release  => './',
    repos    => '',
    key      => {
      'id'     => '27263FA42553615F904A7EBE2A40A2ECB8DAD8D5',
      'server' => 'subkeys.pgp.net',
    },
    include  => {
      'src' => false,
      'deb' => true,
    },
  }

}
