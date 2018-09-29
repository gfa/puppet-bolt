# Main entry point for puppet

node default {
  include packages
}

node pi {
  include interactive
}
