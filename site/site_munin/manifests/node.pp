# this class configures munin-node and friends
#

class site_munin::node {

  include munin::node
  include site_munin::node::plugins

}
