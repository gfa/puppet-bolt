# this class manages the locations we configure by default
#
# @param vhost_name hostname of the vhost
#

define profile::service::nginx::default_locations (
  String $vhost_name,
) {

  nginx::resource::location { "${vhost_name}_dehydrated":
    location_alias => '/var/lib/dehydrated/acme-challenges',
    location       => '/.well-known/acme-challenge',
    server         => $vhost_name,
    index_files    => [],
  }

  # not yet supported :(
  # nginx::resource::location { "${vhost_name}_favicon":
  #   location       => '/favicon.ico',
  #   access_log     => 'off',
  #   server         => $vhost_name,
  #   index_files    => [],
  # }

}
