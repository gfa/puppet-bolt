# Class: tor::install
class tor::install inherits tor {
  assert_private()

  package { $tor::package_name:
    ensure => $tor::package_ensure,
  }
}
