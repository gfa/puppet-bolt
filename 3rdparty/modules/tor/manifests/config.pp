# Class: tor::config
class tor::config inherits tor {
  assert_private()

  file { $tor::config_dir:
    ensure  => directory,
    purge   => true,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
