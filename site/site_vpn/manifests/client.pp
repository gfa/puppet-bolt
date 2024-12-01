# this class manages the client config for
# my vpn
#
class site_vpn::client (
  Array[Stdlib::IP::Address] $additional_allowed_ips = []
) {

  include site_vpn::common

  # change the format for the lookup to work
  $server_hostname = regsubst(lookup('wireguard::server::hostname'), '\.', '_', 'G')
  $ip_last = (fqdn_rand(253, 'wireguard inner ip') + 1)

  wireguard::interface { 'vpn0':
    dport                => lookup('wireguard::port'),
    endpoint             => sprintf('%s:%s', lookup('wireguard::server::hostname'), lookup('wireguard::port')),
    addresses            => [{'Address' => "192.168.99.${ip_last}/24",},{'Address' => "fc00::abcd:${ip_last}/64"}],
    public_key           => lookup('facts_db', Hash, deep, undef)[$server_hostname]['wireguard_pubkeys']['vpn0'],
    persistent_keepalive => 5,
    mtu                  => 1450,
    provider             => lookup('wireguard::provider', Enum['systemd', 'wgquick'], undef, 'wgquick'),
    firewall_mark        => lookup('wireguard::firewall_mark', Integer[0, 4294967295], undef, 1),
  }

  $allowed_ips = [ "192.168.99.${ip_last}", "fc00::abcd:${ip_last}" ] + $additional_allowed_ips

  if $facts['wireguard_pubkeys'] {
    file { '/etc/facter/facts.d/vpn0_peer_config.yaml':
      content => @("YAML"),
            ---
            vpn0_peer_config:
              public_key: ${facts['wireguard_pubkeys']['vpn0']}
              persistent_keepalive: 5
              allowed_ips: ${allowed_ips}
              description: ${facts['networking']['fqdn']}
            | YAML
    }
  }
}
