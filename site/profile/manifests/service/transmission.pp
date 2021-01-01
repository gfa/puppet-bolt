# this class manages transmission
#
class profile::service::transmission {

  include profile::networking::firewall::service::transmission
  include transmission

  file { '/usr/local/bin/transmission-cleanup':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => epp("${module_name}/usr/local/bin/transmission-cleanup.epp"),
  }

}
