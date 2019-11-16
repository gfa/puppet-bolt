# This class manages the firewall for a mysql server
#

class site_mysql::server::firewall {

  firewall { '201 Allow connections to MySQL':
    chain  => 'INPUT',
    proto  => 'tcp',
    state  => 'NEW',
    dport  => '3306',
    action => 'accept',
  }

}
