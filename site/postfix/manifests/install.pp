# @api private
# This class handles packages. Avoid modifying private classes.

class postfix::install {

  $postfix::packages.each|$package|{
    package { $package:
      ensure => installed,
    }
  }

}
