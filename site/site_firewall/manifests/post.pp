# Rules added at the end of the iptables chains
#

class site_firewall::post {

  Firewall { before => undef, }

}
