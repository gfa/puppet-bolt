# this class configures fail2ban, the basis
#
# @param blocklist_de_params contains the local parameters for blocklist.de action
#

class site_firewall::fail2ban (
  Hash $blocklist_de_params = lookup('site_firewall::fail2ban::blocklist_de_params'),
) {

  package { 'sshguard':
    ensure => purged,
  }

  -> class { 'fail2ban':
    bantime   => 3600,
    findtime  => 600,
    logtarget => 'SYSLOG',
    chain     => 'FILTERS',
  }

  $ini_defaults = { 'path' => '/etc/fail2ban/action.d/blocklist_de.local' }
  create_ini_settings($blocklist_de_params, $ini_defaults)

  $ssh_params = lookup('fail2ban::jail::sshd')
  fail2ban::jail { 'sshd':
    filter => 'sshd[mode=aggressive]',
    *      => $ssh_params,
  }

}
