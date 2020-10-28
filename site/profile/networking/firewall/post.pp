# Rules added at the end of the iptables chains
#

class profile::networking::firewall::post {

  Firewallchain <| title == 'INPUT:filter:IPv6' |> {
    policy => 'drop',
    before => undef,
  }

  Firewallchain <| title == 'INPUT:filter:IPv4' |> {
    policy => 'drop',
    before => undef,
  }

  Firewallchain <| title == 'FORWARD:filter:IPv6' |> {
    policy => 'drop',
    before => undef,
  }

  Firewallchain <| title == 'FORWARD:filter:IPv4' |> {
    policy => 'drop',
    before => undef,
  }

  Firewallchain <| title == 'OUTPUT:filter:IPv6' |> {
    policy => 'drop',
    before => undef,
    require  => Service['dnsmasq'],
  }

  Firewallchain <| title == 'OUTPUT:filter:IPv4' |> {
    policy   => 'drop',
    before   => undef,
    require  => Service['dnsmasq'],
  }

  exec { 'start_fail2ban':
    command => '/usr/sbin/invoke-rc.d fail2ban start',
  }

}
