# this class manages blocklists
# IPs on the blocklist(s) are not allowed
# to contact us, neither we are allow to
# contact them
#
# @param countries_block countries to block in alpha-2 format
# @param countries_allow countries to allow in alpha-2 format
#

class site_firewall::blocklists (
  Array[String[2,2]] $countries_block,
  Array[String[2,2]] $countries_allow,
) {

  file { '/etc/cron.hourly/update-ipsets-blocklists':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${module_name}/update-ipsets-blocklists",
  }

  file { '/etc/cron.hourly/update-ipsets-blocklist.de':
    ensure => absent,
  }

  file { '/etc/cron.daily/update-countries-ipset':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => epp("${module_name}/update-countries-ipset.epp",{
        'countries_block' => join($countries_block, ' '),
        'countries_allow' => join($countries_allow, ' '),
    }),
  }

  $update_ipsets_content = "
    @reboot root /etc/cron.daily/update-countries-ipset
    @reboot root /etc/cron.daily/update-ipsets-blocklists
    "

  file { '/etc/cron.d/update-ipsets':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => $update_ipsets_content,
  }

  firewall { '002 block botnets input ip4':
    chain    => 'INPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'iptables',
    ipset    => 'block4 src',
  }

  firewall { '002 block botnets input ip6':
    chain    => 'INPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    ipset    => 'block6 src',
  }

  firewall { '002 block botnets output ip4':
    chain    => 'OUTPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'iptables',
    ipset    => 'block4 dst',
  }

  firewall { '002 block botnets output ip6':
    chain    => 'OUTPUT',
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    ipset    => 'block6 dst',
  }

}
