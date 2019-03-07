# This class manages ipsets
# i'd love to use any of the 3 puppet modules that manage ipsets
# but they don't support Debian, neither iptables-persistent :(
#
# @param ipsets contains a hash with ipsets and their parameters
#

class site_firewall::ipset (
  Hash $ipsets,
) {

  # w8t for buster
  # package { 'ipset-persistent':
  #   ensure => present,
  # }

  file { '/etc/iptables/ipsets':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  $ipsets.each |$name, $data| {
    file_line { $name:
      path   => '/etc/iptables/ipsets',
      line   => "create ${name} ${data['type']} family ${data['family']} hashsize 1024 maxelem 65536",
      notify => Service['netfilter-persistent'],
    }
  }
}
