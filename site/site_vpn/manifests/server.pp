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
    mtu                  => 1450,
    notify               => Service['wg-quick@vpn0'],
  }

  firewall_multi { '100 accept incoming wg':
    dport    => lookup('wireguard::port'),
    proto    => 'udp',
    chain    => 'INPUT',
    action   => 'accept',
    provider => ['iptables', 'ip6tables'],
  }

  $allowed_ips = [ "192.168.99.${ip_last}", "fc00::abcd:${ip_last}" ]

  if $facts['wireguard_pubkeys'] {
    file { '/etc/facter/facts.d/vpn0_peer_config.yaml':
      content => @("YAML"),
            ---
            vpn0_peer_config:
              public_key: ${facts['wireguard_pubkeys']['vpn0']}
              allowed_ips: ${allowed_ips}
              persistent_keepalive: 5
              description: ${facts['networking']['fqdn']}
            | YAML
    }
  }

}
