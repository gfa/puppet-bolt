# this class configures fail2ban
#
# @param blocklist_de_params contains the local parameters for blocklist.de action
#

class profile::networking::firewall::fail2ban (
  Hash $blocklist_de_params = lookup('site_firewall::fail2ban::blocklist_de_params'),
  Hash $infrastructure = lookup('infrastructure'),
  Array $ignore_ips = [],
) {

  include profile::networking::firewall::fail2ban::openssh

  package { 'sshguard':
    ensure => purged,
  }

  package {'python3-systemd':
    ensure => installed,
  }

  # data structure
  #
  # infrastructure:
  #  hosts:
  #  foo:
  #    ipv4:
  #      - 1.2.3.4
  #    ipv6:
  #     - 2001:0db8:85a3:0000:0000:8a2e:0370:7334
  #     - 2001:0db8:85a3:0000:0000:8a2e:0370:7331
  #  bar:
  #    ipv4:
  #      - 4.5.6.7

  if $ignore_ips.length > 0 {
    $ignoreip = $ignore_ips
  } else {
    $all_hosts = $infrastructure[hosts].keys
    $ignoreipv4 =  $all_hosts.map | $host | { "${infrastructure[hosts][$host][ipv4]}" }
    $ignoreipv6 =  $all_hosts.map | $host | { "${infrastructure[hosts][$host][ipv6]}" }
    $ignoreip = $ignoreip4 + $ignoreipv6
  }

  class { 'fail2ban':
    bantime   => 3600,
    findtime  => 600,
    logtarget => 'SYSLOG',
    chain     => 'FILTERS',
    usedns    => 'yes',
    backend   => 'systemd',
    ignoreip  => $ignoreip,
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
