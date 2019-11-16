# this class handles the alternatives
#

class profile::package::alternatives {

  if $facts['os']['distro']['codename'] != 'stretch' {

    alternatives { 'iptables':
      path =>  '/usr/sbin/iptables-legacy',
    }

    alternatives { 'ip6tables':
      path =>  '/usr/sbin/ip6tables-legacy',
    }

  }

}
