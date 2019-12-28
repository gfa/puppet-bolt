# this class configures hostname based ipsets in dnsmasq
#
# @param ipset_name the name of the ipset
# @param ipset_hosts fqdn that should be contained in the ipset
# @param ipset_type the type of the ipset, optional, by default hash:net
#


define profile::networking::service::dnsmasq::ipset (
  Array[String] $ipset_hosts,
  String $ipset_name = $title,
  Enum['hash:ip','hash:net'] $ipset_type = 'hash:net',
) {

  file { "/etc/dnsmasq.d/20-${ipset_name}-ipset":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/networking/firewall/dnsmasq-ipset.erb"),
    notify  => Service['dnsmasq'],
    require => Package['dnsmasq'],
  }

  # dnsmasq won't create the ipsets by itself
  profile::networking::firewall::ipset { $ipset_name:
    ipset_type => $ipset_type,
  }

}
