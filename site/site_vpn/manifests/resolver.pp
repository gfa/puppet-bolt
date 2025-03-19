# this class manages dns resolution for vpn hosts
#
class site_vpn::resolver {

  $facts_db = lookup('facts_db', Hash, deep, {})
  $clients = compact($facts_db.map | $key, $value | { if $value['vpn0_peer_config'] { $value['vpn0_peer_config'] } })
  $server_hostname = regsubst(lookup('wireguard::server::hostname'), '\.', '_', 'G')
  $server_data = $facts_db[$server_hostname]

  if $clients.length > 0 {
    if $server_data['networking'] {
      file { '/etc/dnsmasq.d/20-vpn.conf':
        content => template("${module_name}/etc/dnsmasq.d/20-vpn.conf.erb"),
        notify  => Service['dnsmasq'],
      }
    }
  }
}
