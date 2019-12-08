# this class manages an http vhost using dehydrated to provide the ssl
# certificates and redirection from http to http
# it is a thin wrapper around the module to configure vhosts the way I like
#
# @param ssl_vhosts contains all the ssl vhosts and their configuration
#
# hiera example
# profile::service::nginx::vhost::ssl::ssl_vhosts:
#   smokeping:
#     root: /usr/share/smokeping/www
#     locations:
#       /:
#         try_files $uri $uri/ =404
#       /.well-known/acme-challenge:
#         alias /var/lib/dehydrated/acme-challenges
#       /favicon.ico:
#         log_not_found off

class profile::service::nginx::vhost::ssl (
  Hash $ssl_vhosts,

) {

  include profile::security::ssl::dehydrated
  include profile::service::nginx

  $ssl_vhosts.each |String $vhost, $config| {

    # automatic append the domain name if it is not there
    if $vhost =~ /\./ {
      $vhost_fqdn = $vhost
    } else {
      $vhost_fqdn = "${vhost}.${facts}['networking']['domain']"
    }

    nginx::resource::server { $vhost_fqdn:
      server_name  => [$vhost_fqdn],
      www_root     => $config['root'],
      listen_port  => 443,
      ssl_port     => 443,
      ssl          => true,
      ssl_cert     => "/var/lib/dehydrated/certs/${vhost_fqdn}/fullchain.pem",
      ssl_key      => "/var/lib/dehydrated/certs/${vhost_fqdn}/privkey.pem",
      access_log   => "/var/log/nginx/${vhost_fqdn}.access.log",
      error_log    => "/var/log/nginx/${vhost_fqdn}.error.log",
      ssl_redirect =>  true,
      index_files  => ['index.html'],
    }

  }

}

