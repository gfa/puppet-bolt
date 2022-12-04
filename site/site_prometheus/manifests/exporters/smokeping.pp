# this class configures the prometheus smokeping exporter
#
# @param parameters
#
class site_prometheus::exporters::smokeping (
  Optional[String[1]] $parameters,
) {

  debconf { 'prometheus-smokeping-prober/want_cap_net_raw':
    type  => 'boolean',
    value => 'true',
    seen  => 'true',
  }

  package { 'prometheus-smokeping-exporter':
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
    require => Package['prometheus-smokeping-exporter'],
  }

}
