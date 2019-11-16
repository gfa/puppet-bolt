# base class
#

class base {

  # modules that take their configuration fully from hiera
  include apt
  include needrestart

  # profiles included in all servers

  # hw
  include profile::hardware::gce

  # networking
  include profile::networking::services::dnsmasq
  include profile::networking::services::ntp::client
  include profile::networking::services::resolvconf

  # package management
  include profile::package::base_packages
  include profile::package::pinning
  include profile::package::unattended_upgrades

  # services
  include profile::services::disable_puppet
  include profile::services::openssh::server

  # logging
  include profile::logging::logcheck

  # old stuff to be refactored
  include site_firewall
  include site_firewall::ipset
  include site_firewall::blocklists
  include site_munin::node
  include site_root
  # include site_files
  include site_alternatives
  include site_facts


  include site_ssl

  # include roles from hiera
  # use a default emtpy class as default result
  # so the include never fails
  lookup({
      name          => 'classes',
      merge         => 'deep',
      default_value => 'base::empty',
  }).include
}
