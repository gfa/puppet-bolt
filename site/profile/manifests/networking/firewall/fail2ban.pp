# this class removes fail2ban
#

class profile::networking::firewall::fail2ban {

  package { 'fail2ban':
    ensure => purged,
  }

}
