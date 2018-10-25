# This is the base class to manage a firewall using puppet
#

class site_firewall {

  include firewall

  # purge other firewall rules
  resources { 'firewall':
    purge => true,
  }

  # ignore fail2ban rules
  Firewallchain <| title == 'FILTER:filter:IPv4' |> {
    ignore +> [ '-j DROP', '-j RETURN', '-j REJECT' ],
  }

  Firewallchain <| title == 'FILTER:filter:IPv6' |> {
    ignore +> [ '-j DROP', '-j RETURN', '-j REJECT' ],
  }

  Firewall {
    before  => Class['site_firewall::post'],
    require => Class['site_firewall::pre'],
  }

  contain site_firewall::pre
  contain site_firewall::post
}
