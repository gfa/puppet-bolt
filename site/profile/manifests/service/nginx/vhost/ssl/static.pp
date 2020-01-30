# this class configures static nginx vhosts
#
# @param vhosts_config contains an array of key-values with the vhost and the www_root
#
# example:
# profile::service::nginx::vhost::ssl::static:vhost_config:
#   - foo:
#     www_root: /var/www/bar
#     additional_fqdns: foo.xyz
#

class profile::service::nginx::vhost::ssl::static (
  Array[Hash] $vhosts_config,
) {

  $vhosts_config.each |Integer $index, Hash $vhost_data| {

    # automatic append the domain name if isn't there
    if $vhost_data.keys[0] =~ /\./ {
      $vhost_fqdn = $vhost_data.keys[0]
    } else {
      $vhost_fqdn = "${vhost_data}.keys[0].${facts['networking']['domain']}"
    }

    profile::service::nginx::vhost::ssl { $vhost_fqdn:
      vhost_name  => $vhost_data.keys[0],
      vhosts      => concat([$vhost_fqdn], $vhost_data['additional_fqdns']),
      www_root    => $vhost_data['www_root'],
      headers     => $vhost_data['headers'],
      locations   => $vhost_data['locations'],
      index_files => $vhost_data['index_files'],
    }
  }
}
