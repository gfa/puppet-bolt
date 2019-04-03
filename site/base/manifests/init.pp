# base class
#

class base {

  # IPv6 is broken in GCE
  if $facts['dmi']['bios']['vendor'] == 'Google' {
    class { 'gai::preferipv4': }
  }

  include apt
  include base::disable_puppet
  include base::packages
  include site_firewall
  include site_firewall::ipset
  include base::dnsmasq
  include base::resolvconf
  include base::unattended_upgrades
  include base::ntp
  include needrestart
  include site_munin::node
  include site_tor::sshd

  class { 'ssh':
    validate_sshd_file => true,
  }

  include site_ssl

  # include classes from hiera
  # use a default emtpy class as default result
  # so the include never fails
  lookup({
      name          => 'classes',
      merge         => 'deep',
      default_value => 'base::empty',
  }).include
}
