# this class manages 'static' ipsets, they are added in /etc/iptables/ipset
# if they need updating something else takes care of that
#
# for ipsets which are dns based and updated by dnsmasq see
# profile::networking::services::dnsmasq::ipset
#
# @param ipset_name contains the name and the type of the ipset.
# Two sets will be created, one for ipv4 and other for ipv6
# @param ipset_type type of ipset to create, by default 'hash:net'

define profile::networking::firewall::ipset (
  String[1, 35] $ipset_name = $title,
  Enum['hash:ip', 'hash:net'] $ipset_type = 'hash:net'
) {


  $content4 = "create ${ipset_name}4 ${ipset_type} family inet hashsize 1024 maxelem 65536"
  $content6 = "create ${ipset_name}6 ${ipset_type} family inet6 hashsize 1024 maxelem 65536"

  concat::fragment { $ipset_name:
    target  => '/etc/iptables/ipset',
    content => "${content4}\n${content6}\n",
    require => Package['ipset-persistent'],
    notify  => Service['netfilter-persistent'],
  }

}
