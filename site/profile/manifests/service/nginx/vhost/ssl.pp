# this class manages a https vhost on a machine
#
# @param vhost_name contains the name of the vhost
# @param vhosts contains all the vhosts that will be served
# @param www_root contains the document root of the vhost
# @param headers override the default headers
# @param locations override the default locations
# @param index_files override the default index_files
#

define profile::service::nginx::vhost::ssl (
  String $vhost_name,
  Array[String] $vhosts,
  Stdlib::Absolutepath $www_root,
  Optional[Hash] $headers = undef,
  Optional[Hash] $locations = undef,
  Optional[Array] $index_files = undef,
) {

  include profile::security::ssl::dehydrated
  include profile::service::nginx

  profile::service::nginx::default_locations { $vhost_name:
    vhost_name => $vhost_name,
  }

  $dehydrated_path = '/var/lib/dehydrated/certs'
  $nginx_logs_path = '/var/log/nginx'

  if $headers == undef {
    $headers_to_add =  {
      'Strict-Transport-Security' => {'max-age=31536000; includeSubDomains' => 'always'},
      'X-Frame-Options'           => 'DENY',
      'X-Content-Type-Options'    => 'nosniff',
    }
  }

  if $locations == undef {
    $vhost_locations =  {
      'foo' => 'bar',
    }
  }

  # TODO: remove when the module has better defaults
  # https://github.com/voxpupuli/puppet-nginx/issues/1219
  if $index_files == undef {
    $entrypoints = ['index.html']
  }

  nginx::resource::server { $vhost_name:
    server_name  => $vhosts,
    access_log   => "${nginx_logs_path}/${vhost_name}.access.log",
    error_log    => "${nginx_logs_path}/${vhost_name}.error.log",
    ssl_redirect => true,
  }

  nginx::resource::server { "${vhost_name}_ssl":
    server_name               => $vhosts,
    www_root                  => $www_root,
    index_files               => $entrypoints,
    access_log                => "${nginx_logs_path}/${vhost_name}.access.log",
    error_log                 => "${nginx_logs_path}/${vhost_name}.error.log",
    listen_port               => 443,
    ssl_cert                  => "${dehydrated_path}/${vhost_name}/fullchain.pem",
    ssl_key                   => "${dehydrated_path}/${vhost_name}/privkey.pem",
    ssl_port                  => 443,
    ssl_ciphers               => 'AES256+EECDH:AES256+EDH:!aNULL',
    ssl_stapling              => true,
    ssl_stapling_verify       => true,
    ssl_ecdh_curve            => 'secp384r1',
    ssl_session_timeout       => '10m',
    ssl_protocols             => 'TLSv1.2',
    ssl_prefer_server_ciphers => 'on',
    ssl                       => true,
    add_header                => $headers_to_add,
  }

}
