# this class sets common firewall rules and loads rules from hiera
#
# @param firewall_multis contains the firewall rules to be applied
#

class site_firewall::common (
  Hash[String, Hash] $firewall_multis,
) {

  $firewall_multis.each |$name, $firewall_multi| {
    firewall_multi { $name:
      * => $firewall_multi,
    }
  }
}
