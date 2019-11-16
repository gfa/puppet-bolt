# this class configures munin-node and friends
#

class profile::monitoring::munin::node {

  include munin::node
  include profile::monitoring::munin::node::async
  include profile::monitoring::munin::node::plugins

}
