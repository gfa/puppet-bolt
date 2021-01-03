# this class manages wireguard in the dn42 context
#
# @param peerings hash containing peerings
# @param ipv4_own my own dn42 ip4 address
# @param ipv6_own my own dn42 ip6 address
#

class profile::networking::dn42::wireguard (
  Optional[Array] $peerings = undef,
  Stdlib::IP::Address::V4::Nosubnet $ipv4_own = lookup('site_bird::ipv4_own'),
  Stdlib::IP::Address::V6::Nosubnet $ipv6_own = lookup('site_bird::ipv6_own'),
) {

  package { 'wireguard': }

  file { '/etc/network/interfaces.d':
    ensure => directory,
  }

  file_line { 'include /etc/network/interfaces.d/ configuration':
    path  => '/etc/network/interfaces',
    line  => "\nsource /etc/network/interfaces.d/*.cfg\n",
    match => '^source \/etc\/network\/interfaces\.d/\*\.cfg',
  }

  if $peerings {

    $peerings.each | Integer $index, Hash $peer | {

      file { "/etc/network/interfaces.d/wg${index}.cfg":

        ensure  => file,
        content => epp(
          "${module_name}/etc/network/interfaces.d/wg.epp",
          {
            'index'    => $index,
            'peer'     => $peer,
            'ipv4_own' => $ipv4_own,
            'ipv6_own' => $ipv6_own,
          }
        ),
        require => Package['wireguard'],
        notify  => Exec['ifup --all'],
      }
    }

    systemd::unit_file { 'wireguard-tunnels.service':
      content => epp("${module_name}/etc/systemd/system/wireguard-tunnels.service.epp"),
    }

    service {'wireguard-tunnels':
      enable => true,
    }

  }

  exec { 'ifup --all':
    path        => ['/sbin', '/usr/sbin'],
    user        => 'root',
    refreshonly => true,
  }

}
