# this class configures bird peerings
#
# @param peerings
#

class site_bird::peerings (
  Optional[Array] $peerings = undef,
) {

  if $peerings {

    $peerings.each | Integer $index, Hash $peer | {

      $peer_name = $peer.keys()[0]
      $peer_params = {
        name      => $peer_name,
        interface => "wg${index}",
      }

      file { "/etc/bird/peers/${peer_name}.conf":
        ensure  => file,
        content => epp(
          "${module_name}/etc/bird/peers/peer.conf.epp",
          { 'peer_name' => $peer_name,
            'interface' => "wg${index}",
          } + $peer,
        ),
        require => [
          Package['wireguard'],
          Package['bird2'],
        ],
        notify  => Exec['birdc configure'],
      }
    }

  }

  exec { 'birdc configure':
    command     => 'birdc configure',
    refreshonly => true,
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', ],
  }

}
