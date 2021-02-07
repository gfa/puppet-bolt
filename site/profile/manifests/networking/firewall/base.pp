# things I always expect to have around
#
# tends to atract debt :\
#
# @param ipsets contains a hash with ipsets to be created per host
# @param infrastructure descripts the infrastructure
#

class profile::networking::firewall::base (
  Hash $ipsets,
  Hash $infrastructure = lookup('infrastructure'),
) {

  package { 'ipset-persistent':
    ensure => latest,
  }

  concat { '/etc/iptables/ipsets':
    ensure  => present,
    require => Package['ipset-persistent'],
  }

  $ipsets.each |$name, $hash| {
    if $hash['hosts'] {
      profile::networking::service::dnsmasq::ipset { $name:
        ipset_hosts => $hash['hosts'],
        ipset_type  => $hash['type'],
      }
    }
    else {
      profile::networking::firewall::ipset { $name:
        ipset_type => $hash['type'],
      }
    }
  }

  profile::networking::service::dnsmasq::ipset { 'myhosts':
    ipset_hosts => $infrastructure['hosts'].keys(),
    ipset_type  => 'hash:ip',
  }

  file { '/etc/default/netfilter-persistent':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('profile/networking/firewall/netfilter-persistent.erb'),
  }

}
