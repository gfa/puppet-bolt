# this class configures static nginx vhosts
#
# @param vhost_config contains key-values with the vhost and the www_root
#
# example:
# profile::service::nginx::vhost::ssl::static:vhost_config:
#   foo: /var/www/bar
#   bar.example.net: /var/www/baz
#

class profile::service::nginx::vhost::ssl::static (
    Hash[String, Stdlib::UnixPath] $vhost_config,
) {

  $vhost_config.each |$vhost| {

    # automatic append the domain name if isn't there
    if $vhost[0] =~ /\./ {
      $vhost_fqdn = $vhost[0]
    } else {
      $vhost_fqdn = "${vhost[0]}.${facts['networking']['domain']}"
    }

    profile::service::nginx::vhost::ssl { $vhost_fqdn:
      vhost_name => $vhost[0],
      vhosts     => [$vhost_fqdn],
      www_root   => $vhost[1],
    }
  }

}
