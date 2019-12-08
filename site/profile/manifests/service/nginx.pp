# entry point for nginx configuration
# keep as much as Debian defaults as possible
# https://github.com/voxpupuli/puppet-nginx/issues/1359
#
# @param client_max_body_size max upload size on this server. default is 1m
# @param dehydrated_support if to enable dehydrated support on the default vhost

class profile::service::nginx (
  Optional[String] $client_max_body_size = '1m',
  Optional[Boolean] $dehydrated_support = true,
) {

  class {'nginx':
    confd_purge           => true,
    server_purge          => true,
    http2                 => 'on',
    server_tokens         => 'off',
    package_flavor        =>  'light',
    # XXX: doesn't work because a default is specified in the
    # class. doesn't matter much because the puppet module reuses
    # upstream default.
    worker_rlimit_nofile  =>  undef,
    accept_mutex          =>  'off',
    # XXX: doesn't work because a default is specified in the
    # class. but that doesn't matter because accept_mutex is off so
    # this has no effect
    accept_mutex_delay    =>  undef,
    http_tcp_nopush       =>  'on',
    gzip                  =>  'on',
    client_max_body_size  =>  $client_max_body_size,
    run_dir               =>  '/run/nginx',
    client_body_temp_path =>  '/run/nginx/client_body_temp',
    proxy_temp_path       =>  '/run/nginx/proxy_temp',
    proxy_connect_timeout =>  '60s',
    proxy_read_timeout    =>  '60s',
    proxy_send_timeout    =>  '60s',
    # XXX: hardcoded, should just let nginx figure it out
    proxy_cache_max_size  =>  '15g',
    proxy_cache_inactive  =>  '24h',
  }
  # recreate the default vhost
  nginx::resource::server { 'default':
    server_name         =>  ['_'],
    www_root            =>  '/var/www/html',
    listen_options      =>  'default_server',
    ipv6_enable         =>  true,
    ipv6_listen_options =>  'default_server',
    ssl                 =>  false,
  }

  if $dehydrated_support == true {
    nginx::resource::location { 'acme-challenge':
      ensure   => present,
      alias    => '/var/lib/dehydrated/acme-challenges',
      location => '/.well-known/acme-challenge',
      server   => '_',
    }
  }

}
