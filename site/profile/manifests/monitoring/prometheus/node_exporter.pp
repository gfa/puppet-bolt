# this class manages the node exporter

# @param prometheus_hosts4 hosts were prometheus runs ipv4
# @param prometheus_hosts6 hosts were prometheus runs ipv6
#
class profile::monitoring::prometheus::node_exporter (
  Array[Stdlib::Host] $prometheus_hosts4 = ['127.0.0.1'],
  Array[Stdlib::Host] $prometheus_hosts6 = ['::1'],
) {

  package { 'prometheus-node-exporter':
    ensure => present,
  }

  if lookup('manage_iptables', Boolean, undef, true) {
    firewall_multi { '400 incoming prometheus ipv4':
      chain    => 'INPUT',
      dport    => 9100,
      proto    => 'tcp',
      action   => 'accept',
      provider => 'iptables',
      source   => $prometheus_hosts4,
    }

    firewall_multi { '400 incoming prometheus ipv6':
      chain    => 'INPUT',
      dport    => 9100,
      proto    => 'tcp',
      action   => 'accept',
      provider => 'ip6tables',
      source   => $prometheus_hosts6,
    }
  }
}
