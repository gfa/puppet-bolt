# base class
#

class base {

  include apt
  include base::packages
  include base::disable_puppet
  include site_firewall
  include site_firewall::ipset

}
