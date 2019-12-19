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
# @param rpc_whitelist_enabled if enabling rpc ip address whitelisting
# @param rpc_whitelist list of ip address to whitelist on rpc
# @param rpc_authentication_required if rpc authentication is required
# @param rpc_host_whitelist fqdn where the rpc server is accesed
# @param rpc_host_whitelist_enabled enable if the server is accessed using hostname
# @param incomplete_dir directory where to store downloads until they finish
# @param incomplete_dir_enabled if enable temporary directory
# @param home_dir home directory for transmission
# @param download_dir directory to save downloads

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
  Boolean $rpc_whitelist_enabled = true,
  String $rpc_whitelist = '127.0.0.1',
  Boolean $rpc_authentication_required = true,
  Boolean $rpc_host_whitelist_enabled = false,
  String $rpc_host_whitelist = 'localhost',
  Boolean $incomplete_dir_enabled = false,
  String $incomplete_dir = 'temp', # relative paths to $home_dir :\
  String $download_dir = 'downloads',
  Stdlib::UnixPath $home_dir = '/var/lib/transmission-daemon',
) {

  include profile::networking::firewall::service::transmission

  class { 'transmission':
    rpc_username                => $rpc_username,
    rpc_password                => $rpc_password,
    rpc_port                    => $rpc_port,
    peer_port                   => $peer_port,
    encryption                  => 2,
    blocklist_url               => $blocklist_url,
    manage_ppa                  => $manage_ppa,
    rpc_whitelist_enabled       => $rpc_whitelist_enabled,
    rpc_whitelist               => $rpc_whitelist,
    rpc_authentication_required => $rpc_authentication_required,
    rpc_host_whitelist          => $rpc_host_whitelist,
    rpc_host_whitelist_enabled  => $rpc_host_whitelist_enabled,
    incomplete_dir              => $incomplete_dir,
    incomplete_dir_enabled      => $incomplete_dir_enabled,
    home_dir                    => $home_dir,
    download_dir                => $download_dir,
    peer_port_random_on_start   => $peer_port_random,
    peer_port_random_low        => $peer_port_random_low,
    peer_port_random_high       => $peer_port_random_high,
  }

}
