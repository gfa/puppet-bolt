# things I always expect to have around
#
# tends to atract debt :\
#
# @param ipsets contains a hash with ipsets to be created per host
#

class profile::networking::firewall::base (
  Hash $ipsets,
) {

  package { 'ipset-persistent':
    ensure => present,
  }

  concat { '/etc/iptables/ipset':
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

}