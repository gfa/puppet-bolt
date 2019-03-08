# this class configures fail2ban, the basis
#

class site_firewall::fail2ban {

  class { 'fail2ban':
    bantime   => 3600,
    findtime  => 600,
    logtarget => 'SYSLOG',
    chain     => 'FILTERS',
  }

  $ssh_params = lookup('fail2ban::jail::sshd')
  fail2ban::jail { 'sshd':
    filter => 'sshd[mode=aggressive]',
    *      => $ssh_params,
  }

}
