# this class manages blocklists
# IPs on the blocklist(s) are not allowed
# to contact us, neither we are allow to
# contact them
#
# @param countries_block countries to block in alpha-2 format
# @param countries_allow countries to allow in alpha-2 format
#

class profile::networking::firewall::blocklists (
  Array[String[2,2]] $countries_block,
  Array[String[2,2]] $countries_allow,
) {

  require profile::networking::firewall::base

  file { '/etc/cron.hourly/update-ipsets-blocklists':
    ensure => absent,
  }

  file { '/usr/local/bin/update-ipsets-blocklists':
    ensure => file,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${module_name}/networking/firewall/update-ipsets-blocklists",
    notify => Exec['update_ipsets_blocklists'],
  }

  exec { 'update_ipsets_blocklists':
    command     => '/usr/local/bin/update-ipsets-blocklists',
    refreshonly => true,
  }

  file { '/etc/cron.hourly/update-ipsets-blocklist.de':
    ensure => absent,
  }

  file { '/etc/cron.daily/update-countries-ipset':
    ensure  => absent,
  }

  file { '/usr/local/bin/update-countries-ipset':
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => epp("${module_name}/networking/firewall/update-countries-ipset.epp",{
        'countries_block' => join($countries_block, ' '),
        'countries_allow' => join($countries_allow, ' '),
    }),
  }

  # TODO: make this a systemd timer and depend on network-online.target
  $update_ipsets_content = "
    @reboot root sleep 5m ; /usr/local/bin/update-countries-ipset
    @reboot root sleep 5m ; /usr/local/bin/update-ipsets-blocklists
    */60 * * * * root /usr/local/bin/cronrunner /usr/local/bin/update-ipsets-blocklists
    59 */24 * * * root /usr/local/bin/cronrunner /usr/local/bin/update-countries-ipset
    "

  file { '/etc/cron.d/update-ipsets':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => $update_ipsets_content,
  }

  # lint:ignore:security_firewall_any_any_deny
  firewall { '002 block botnets input ip4':
    chain    => 'INPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'iptables',
    ipset    => 'block4 src',
    require  => File['/etc/cron.hourly/update-ipsets-blocklists'],
  }

  firewall { '002 block botnets input ip6':
    chain    => 'INPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    ipset    => 'block6 src',
    require  => File['/etc/cron.hourly/update-ipsets-blocklists'],
  }

  firewall { '002 block botnets output ip4':
    chain    => 'OUTPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'iptables',
    ipset    => 'block4 dst',
    require  => File['/etc/cron.hourly/update-ipsets-blocklists'],
  }

  firewall { '002 block botnets output ip6':
    chain    => 'OUTPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    ipset    => 'block6 dst',
    require  => File['/etc/cron.hourly/update-ipsets-blocklists'],
  }
  # lint:endignore

}
