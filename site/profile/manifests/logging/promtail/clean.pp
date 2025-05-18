# this class cleans up promtail
#
class profile::logging::promtail::clean {

  package { 'promtail':
    ensure  => purged,
  }

  file { '/etc/promtail/config.yml':
    ensure  => absent,
  }

  service { 'promtail':
    ensure => stopped,
    enable => false,
  }

  user { 'promtail':
    ensure  =>  absent,
  }

}
