include ::tor

tor::instance { 'default':
  ensure   => present,
  settings => {
    Nickname => 'default',
    OrPort   => 9050,
    DirPort  => 9030,
  },
}

tor::instance { 'test1':
  ensure   => present,
  settings => {
    Nickname => 'test1',
    OrPort   => 9050,
    DirPort  => 9030,
  },
}

tor::instance { 'test2':
  ensure => absent,
}
