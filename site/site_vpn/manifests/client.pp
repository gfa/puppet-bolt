# this class manages the client config for
# my vpn
#
class site_vpn::client {

  include site_vpn::common

  $ip_last = fqdn_rand(254, 'wireguard inner ip')

  # change the format for the lookup to work
  $server_hostname = regsubst(lookup('wireguard::server::hostname'), '\.', '_', 'G')

  wireguard::interface { 'vpn0':
    dport                => lookup('wireguard::port'),
    endpoint             => sprintf('%s:%s', lookup('wireguard::server::hostname'), lookup('wireguard::port')),
    addresses            => [{'Address' => "192.168.99.${ip_last}/24",},{'Address' => "fc00::abcd:${ip_last}/64"}],
    public_key           => lookup('facts_db', Hash, deep, undef)[$server_hostname]['wireguard_pubkeys']['vpn0'],
    persistent_keepalive => 5,
    mtu                  => 1412,
    provider             => lookup('wireguard::provider', Enum['systemd', 'wgquick'], undef, 'wgquick'),
  }

}
