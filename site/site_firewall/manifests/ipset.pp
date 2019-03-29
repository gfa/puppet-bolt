# This class manages ipsets
# i'd love to use any of the 3 puppet modules that manage ipsets
# but they don't support Debian, neither iptables-persistent :(
#
# @param ipsets contains a hash with ipsets and their parameters
#

class site_firewall::ipset (
  Hash $ipsets,
) {

  # w8t for buster backports
  # package { 'ipset-persistent':
  #   ensure => present,
  # }

  file { '/etc/default/netfilter-persistent':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('site_firewall/netfilter-persistent.erb'),
  }

  file { '/etc/iptables/ipsets':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('site_firewall/ipsets.erb'),
    notify  => Service['netfilter-persistent'],
  }

  $ipsets.each |$name, $hash| {
    if $hash['hosts'] {
      file { "/etc/dnsmasq.d/20-${name}-ipset":
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template('site_firewall/dnsmasq-ipset.erb'),
        notify  => Service['dnsmasq'],
        require => Package['dnsmasq'],
      }
    }
  }
}
