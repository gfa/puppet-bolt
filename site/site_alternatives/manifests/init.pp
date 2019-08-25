# this class handles the alternatives
#

class site_alternatives {

  alternatives { 'iptables':
    path =>  '/usr/sbin/iptables-legacy',
  }

  alternatives { 'ip6tables':
    path =>  '/usr/sbin/ip6tables-legacy',
  }

}
