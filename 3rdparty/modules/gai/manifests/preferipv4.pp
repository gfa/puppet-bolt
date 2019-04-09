# preferipv4.pp --- Class gai::preferipv4
#
# @summary Define precedence table in /etc/gai.conf to prefer IPv4
#
# @example Declaring the class
#
#   include puppet-gai::preferipv4
#
#
class gai::preferipv4 {

  # Redefine precedence table to prefer IPv4 addresses

  class { '::gai':
    precedence => {
      '::/96'         => '20',
      '2002::/16'     => '30',
      '::/0'          => '40',
      '::1/128'       => '50',
      '::ffff:0:0/96' => '100',
    }
  }
}
