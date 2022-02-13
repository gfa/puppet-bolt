# base class
#
#
class base {

  stage { 'first':
    before => Stage['main'],
  }

  stage { 'last': }

  Stage['main'] -> Stage['last']

  # modules that take their configuration fully from hiera
  include apt
  include needrestart
  include cron

  # profiles included in all servers

  # hw
  include profile::hardware::gce
  include profile::hardware::smartctl

  # networking
  include profile::networking::service::dnsmasq
  include profile::networking::service::ntp::client
  include profile::networking::service::resolvconf
  include profile::networking::firewall
  include profile::networking::hosts

  # package management
  include profile::package::base_packages
  include profile::package::pinning
  include profile::package::unattended_upgrades

  # others
  include profile::package::etckeeper
  include profile::package::cronrunner
  include site_tunnels

  # services
  include profile::service::puppet
  include profile::service::openssh::server
  include profile::service::crond

  # logging
  include profile::logging::logcheck
  include profile::logging::erpel
  include profile::logging::journald::upload

  # monitoring
  include profile::monitoring::munin::remove
  include profile::monitoring::prometheus::node_exporter
  include profile::monitoring::vnstat

  # security
  include profile::security::account::root
  include profile::security::ssl

  #include site_files

  # local facts
  include site_facts

  # include classes from hiera
  $infrastructure = lookup('infrastructure')
  $classes = $infrastructure['hosts'][$facts['fqdn']]['classes']
  $classes.include

}
