# this class configures bbr

class profile::networking::bbr {

  sysctl { 'net.core.default_qdisc':
    ensure => present,
    value  => 'fq',
  }

  sysctl { 'net.ipv4.tcp_congestion_control':
    ensure => present,
    value  => 'bbr',
  }

}
