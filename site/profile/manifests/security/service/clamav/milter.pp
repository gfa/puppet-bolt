# this class manages clamav milter
# it expects clamd to run in the same machine
#
# @param allow_connections_from an array of ip4 addr that are allowed to connect
# @param port port where the milter will listen
# @param listen_on ip4 address on which the milter will listen for connections

class profile::security::service::clamav::milter (
  IP::Address::V4 $allow_connections_from_4 = '127.0.0.1',
  IP::Address::V4 $listen_on = '127.0.0.1',
  Integer $port = 3310,
  Hash $whitelist_addresses = {},
) {

  package { 'clamav-milter':
    ensure => present,
  }

  -> firewall { '300 Allow network access to clamav-milter':
    chain    => 'INPUT',
    dport    => $port,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'iptables',
    source   => $allow_connections_from_4,
  }

}
