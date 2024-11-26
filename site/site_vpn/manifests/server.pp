# this class manages my wireguard server
#
class site_vpn::server {

  include site_vpn::common

  $ip_last = (fqdn_rand(253, 'wireguard inner ip') + 1)
  $facts_db = lookup('facts_db', Hash, deep, {})

  $peers = $facts_db.map | $key, $value | { if $value['vpn0_peer_config'] { $value['vpn0_peer_config'] } }

  wireguard::interface {'vpn0':
    dport                => lookup('wireguard::port'),
    manage_firewall      => false,
    firewall_mark        => lookup('wireguard::firewall_mark', Integer[0, 4294967295], undef, 1),
    provider             => lookup('wireguard::provider', Enum['systemd', 'wgquick'], undef, 'wgquick'),
    peers                => compact($peers),
    addresses            => [{'Address' => "192.168.99.${ip_last}/24",},{'Address' => "fc00::abcd:${ip_last}/64"}],
    persistent_keepalive => 5,
    mtu                  => 1412,
    notify               => Service['wg-quick@vpn0'],
  }

}
