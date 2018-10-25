# base class
#

class base {

  include apt
  include base::packages
  include site_firewall

}
