# this class removes traces of logcheck

class logging::logcheck {

  user { 'logcheck':
    ensure => absent,
  }

  group { 'logcheck':
    ensure => absent,
  }

  file { '/var/lib/logcheck':
    ensure => absent,
  }

}
