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
  include site_munin::node

  # include classes from hiera
  # use a default emtpy class so the lookup()
  # never fails
  lookup({
      name          => 'classes',
      merge         => 'deep',
      default_value => 'base::empty',
  }).include
}
