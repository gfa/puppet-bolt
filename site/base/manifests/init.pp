# base class
#

class base {

  # modules that take their configuration fully from hiera
  include apt
  include needrestart

  # profiles included in all servers

  # hw
  include profile::hardware::gce
  include profile::hardware::smartctl

  # networking
  include profile::networking::service::dnsmasq
  include profile::networking::service::ntp::client
  include profile::networking::service::resolvconf
  include profile::networking::firewall

  # package management
  include profile::package::base_packages
  include profile::package::pinning
  include profile::package::unattended_upgrades
  include profile::package::alternatives

  # services
  include profile::service::disable_puppet
  include profile::service::openssh::server

  # logging
  include profile::logging::logcheck
  include profile::logging::erpel

  # monitoring
  include profile::monitoring::munin::node
  include profile::monitoring::prometheus::node_exporter

  # security
  include profile::security::account::root
  include profile::security::ssl

  #include site_files

  # local facts
  include site_facts

  # include roles from hiera
  # use a default emtpy class as default result
  # so the include never fails
  lookup({
      name          => 'classes',
      merge         => 'deep',
      default_value => 'base::empty',
  }).include
}
