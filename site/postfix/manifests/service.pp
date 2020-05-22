# this class manages the postfix service

class postfix::service {

  service { 'postfix':
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }

}
