# this class configures fail2ban
#
# @param blocklist_de_params contains the local parameters for blocklist.de action
#

class profile::networking::firewall::fail2ban (
  Hash $blocklist_de_params = lookup('site_firewall::fail2ban::blocklist_de_params'),
  Hash $infrastructure = lookup('infrastructure'),
) {

  include profile::networking::firewall::fail2ban::openssh

  package { 'sshguard':
    ensure => purged,
  }

  package {'python3-systemd':
    ensure => installed,
  }

  class { 'fail2ban':
    bantime   => 3600,
    findtime  => 600,
    logtarget => 'SYSLOG',
    chain     => 'FILTERS',
    usedns    => 'yes',
    backend   => 'systemd',
  }

  file { '/etc/fail2ban/action.d/blocklist_de.local':
    ensure => absent,
  }

  systemd::dropin_file { 'fail2ban.conf':
    unit   =>  'fail2ban.service',
    source =>  "puppet:///modules/${module_name}/networking/firewall/fail2ban.override.conf",
  }

  file { '/etc/tmpfiles.d/fail2ban-tmpfiles.conf':
    source => "puppet:///modules/${module_name}/networking/firewall/fail2ban-tmpfiles.override.conf",
  }

}
