# this class manages the node exporter

# @param prometheus_host4 host were prometheus runs ipv4
# @param prometheus_host6 host were prometheus runs ipv6

class profile::monitoring::prometheus::node_exporter (
  Stdlib::Host $prometheus_host4 = '127.0.0.1',
  Stdlib::Host $prometheus_host6 = '::1',
) {

  package { 'prometheus-node-exporter':
    ensure => absent,
  }

}
