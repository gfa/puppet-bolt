# base class
#

class base {

  include apt
  include base::disable_puppet
  include base::packages
  include site_firewall
  include site_firewall::ipset
  include base::dnsmasq
  include base::resolvconf
  include base::unattended_upgrades
  include needrestart

  # include classes from hiera
  hiera_include('classes') | $key | {"Key '${key}' not found" }
}
