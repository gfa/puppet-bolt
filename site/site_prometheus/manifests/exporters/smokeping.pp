# this class configures the prometheus smokeping exporter
#
# @param parameters
#
class site_prometheus::exporters::smokeping (
  Optional[String[1]] $parameters,
  Optional[String[1]] $extra_parameters = ' ',
) {

  debconf { 'prometheus-smokeping-prober/want_cap_net_raw':
    type  => 'boolean',
    value => 'true',
    seen  => 'true',
  }

  package { 'prometheus-smokeping-prober':
    ensure  => installed,
    require => Debconf['prometheus-smokeping-prober/want_cap_net_raw'],
  }

  file { '/etc/default/prometheus-smokeping-prober':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp("${module_name}/etc/default/prometheus-smokeping-prober.epp"),
    notify  => Service['prometheus-smokeping-prober'],
  }

  service { 'prometheus-smokeping-prober':
    ensure  => running,
    enable  => true,
    require => Package['prometheus-smokeping-prober'],
  }

  if lookup('manage_iptables', Boolean, undef, true) {
    firewall { '300 allow incoming smokeping exporter ipv4':
      chain    => 'INPUT',
      dport    => 9374,
      action   => 'accept',
      provider => 'iptables',
      source   => lookup('prometheus_hosts_ipv4', undef, undef , ['127.0.0.1']),
    }
    firewall { '300 allow incoming smokeping exporter ipv6':
      chain    => 'INPUT',
      dport    => 9374,
      action   => 'accept',
      provider => 'ip6tables',
      source   => lookup('prometheus_hosts_ipv6', undef , undef, ['::1']),
    }
  }
}
