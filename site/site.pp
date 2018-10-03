# Main entry point for puppet

node default {
  include packages
  include apt
}

node pi {
  include base
  include interactive
}

node instance-3 {
  include base
  include site_mysql::server
}
