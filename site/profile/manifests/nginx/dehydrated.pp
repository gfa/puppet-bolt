# this class manages nginx configuration to answer letsencrypt http challenges
#

class profile::nginx::dehydrated {

  include nginx

  nginx::resource::server { 'default':
    server_name    => ['_'],
    www_root       => '/var/www/html',
    listen_port    => 80,
    listen_options => 'default_server',
    index_files    => [ 'index.html', 'index.htm', 'index.nginx-debian.html' ]
  }

  nginx::resource::location { '/.well-known/acme-challenge':
    alias  => '/var/lib/dehydrated/acme-challenges',
    server => 'default',
  }

}
