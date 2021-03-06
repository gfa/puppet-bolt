# this class manages wireguard in the dn42 context
#
# @param peerings hash containing peerings, some peers may ask me for a different ipv6_link_local addr
# @param ipv4_own my own dn42 ip4 address
# @param ipv6_own my own dn42 ip6 address
# @param private_key wireguard private key
# @param public_key wireguard public key
# @param ipv6_link_local my link local ipv6 addr for wg tunnels
#
# TODO: move wg bits to its own class
#

class profile::networking::dn42::wireguard (
  String $private_key,
  String $public_key,
  Stdlib::IP::Address::V6::Nosubnet $ipv6_link_local,
  Optional[Array] $peerings = lookup('site_bird::peerings', default_value => undef),
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

  file { '/etc/wireguard/privatekey':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0400',
    content   => Sensitive("${private_key}\n"),
    show_diff => false,
    require   => Package['wireguard'],
  }

  file { '/etc/wireguard/publickey':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => "${public_key}\n",
    require => Package['wireguard'],
  }

  if $peerings {

    $peerings.each | Integer $index, Hash $peer | {

      file { "/etc/network/interfaces.d/wg${index}.cfg":
        ensure  => file,
        content => epp(
          "${module_name}/etc/network/interfaces.d/wg.epp",
          {
            'index'           => $index,
            'peer'            => $peer,
            'ipv4_own'        => $ipv4_own,
            'ipv6_own'        => $ipv6_own,
            'ipv6_link_local' => $ipv6_link_local,
          }
        ),
        require => Package['wireguard'],
        notify  => Exec["ifrestart wg${index}"],
      }

      file { "/etc/wireguard/wg${index}.conf":
        ensure  => file,
        content => epp(
          "${module_name}/etc/wireguard/wg.epp",
          {
            'peer'        => $peer,
            'private_key' => $private_key,
          }
        ),
        require => Package['wireguard'],
        notify  => Exec["ifrestart wg${index}"],

      }

      exec { "ifrestart wg${index}":
        path        => ['/sbin', '/usr/sbin'],
        user        => 'root',
        refreshonly => true,
        command     => "/sbin/ifdown --force wg${index} ; /sbin/ifup wg${index}",
        returns     => [0, 1],
      }
    }

    systemd::unit_file { 'wireguard-tunnels.service':
      content => epp("${module_name}/etc/systemd/system/wireguard-tunnels.service.epp"),
    }

    service {'wireguard-tunnels':
      enable => true,
    }

  }


}
