# this class configures unbound for dn42 hosts
#

class profile::networking::unbound::dn42 {

  include profile::networking::unbound

  file { '/etc/unbound/unbound.conf.d/dn42.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/etc/unbound/unbound.conf.d/dn42.conf",
    require => Package['unbound'],
    notify  => Service['unbound'],
  }

}
