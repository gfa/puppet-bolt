# this profile manages postfix

class profile::service::postfix {

  #include profile::service::postfix::firewall
  include postfix

}
