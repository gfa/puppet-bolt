# this class manages the node exporter

# @param prometheus_host host were prometheus runs

class profile::monitoring::prometheus::node_exporter (
  Stdlib::Host $prometheus_host = '127.0.0.1'
) {

  package { 'prometheus-node-exporter':
    ensure => present,
  }

  firewall { '300 allow prometheus to scrap the node exporter':
    chain  => 'INPUT',
    dport  => 9100,
    proto  => 'tcp',
    action => 'accept',
    source => $prometheus_host,
  }

}
