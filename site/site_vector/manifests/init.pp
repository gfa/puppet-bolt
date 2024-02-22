# this class configures vector.dev
#
class site_vector {

  file { '/etc/apt/trusted.gpg.d/datadog.gpg':
    source => "puppet:///modules/${module_name}/etc/apt/trusted.gpg.d/datadog-archive-keyring.gpg",
  }

  package { 'vector':
    require => [File['/etc/apt/trusted.gpg.d/datadog.gpg'],Exec['apt_update']],
  }

  file { '/etc/vector/vector.yaml':
    require => Package['vector'],
    notify  => Service['vector'],
    owner   => 'root',
    group   => 'vector',
    mode    => '0640',
    content => epp("${module_name}/etc/vector/vector.yaml.epp"),

  }


  service { 'vector':
    ensure  => stopped,
    enable  => false,
    require => [Package['vector'], File['/etc/vector/vector.yaml']]
  }
}
