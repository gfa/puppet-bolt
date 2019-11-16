# this class manages all common munin plugins

class profile::monitoring::munin::node::plugins {

  include profile::monitoring::munin::node::plugin::vnstat
  include profile::monitoring::munin::node::plugin::ipset

}
