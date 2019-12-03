# this class configures fail2ban
#
# @param blocklist_de_params contains the local parameters for blocklist.de action
#

class profile::networking::firewall::fail2ban (
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

  systemd::dropin_file { 'fail2ban.conf':
    unit   =>  'fail2ban.service',
    source =>  "puppet:///modules/${module_name}/networking/firewall/fail2ban.override.conf",
  }

}
