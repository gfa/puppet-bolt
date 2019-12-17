# this class manages transmission
#
# @param blocklist_url url where to download blocklists
# @param peer_port_random_low low port if using random ports
# @param peer_port_random_high high port if using random ports
# @param peer_port port to use if using static ports
# @param peer_port_random if use random ports
# @param rpc_port port used for rpc
# @param rpc_username username for rpc authentication
# @param rpc_password password for rpc authentication
# @param watch_dir_enabled if enable the watchdir
# @param manage_ppa if use packages from ppa
#

class profile::service::transmission (
  String $rpc_username,
  String $rpc_password,
  Stdlib::Port $rpc_port = 9091,
  Stdlib::Port $peer_port_random_low = 49152,
  Stdlib::Port $peer_port_random_high = 65535,
  Stdlib::Port $peer_port = 51413,
  Boolean $peer_port_random = false,
  Boolean $watch_dir_enabled = false,
  Stdlib::HTTPUrl $blocklist_url = 'http://www.example.com/blocklist',
  Boolean $manage_ppa = false,
) {

  include profile::networking::firewall::service::transmission

  class { 'transmission':
    rpc_username  => $rpc_username,
    rpc_password  => $rpc_password,
    rpc_port      => $rpc_port,
    peer_port     => $peer_port,
    encryption    => 2,
    blocklist_url => $blocklist_url,
    manage_ppa    => $manage_ppa,
  }

}
