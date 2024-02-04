# this class manages promtail
#
class profile::logging::promtail (
  $hostname,
  $username,
  $password,
) {

  # repo is managed elsewhere
  file { '/etc/apt/trusted.gpg.d/grafana.asc':
    ensure => file,
    source => "puppet:///modules/${module_name}/etc/apt/trusted.gpg.d/grafana.asc",
  }

  package { 'promtail':
    ensure  => installed,
    require => File['/etc/apt/trusted.gpg.d/grafana.asc'],
  }

  file { '/etc/promtail/config.yml':
    ensure  => file,
    owner   => 'promtail',
    group   => 'root',
    mode    => '0640',
    require => Package['promtail'],
    notify  => Service['promtail'],
    content => epp("${module_name}/etc/promtail/config.yml.epp"),
  }

  service { 'promtail':
    ensure  => running,
    enable  => true,
    require => Package['promtail'],
  }

  user { 'promtail':
    groups  => ['systemd-journal'],
    require => Package['promtail'],
  }

  if lookup('manage_iptables', Boolean, undef, true) {

    firewall { '300 output promtail':
      chain       => 'OUTPUT',
      dport       => 443,
      proto       => 'tcp',
      action      => 'accept',
      destination => $hostname,
      require     => Package['promtail'],
    }
  }

}
