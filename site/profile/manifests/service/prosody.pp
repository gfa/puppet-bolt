# this class manages the local prosody install
#
# @param prosody_fqdn the fqdn behind the prosody server
# @param prosody_domain the domain this prosody server serves
#
# TODO: make this a define and support multiple domains
#

class profile::service::prosody (
  Stdlib::Fqdn $prosody_fqdn,
  Stdlib::Fqdn $prosody_domain,
) {

  include profile::security::ssl::dehydrated
  include profile::monitoring::munin::node::plugin::prosody

  package { 'prosody-modules':
    ensure => present,
  }

  class { 'prosody':
    authentication    => 'internal_plain',
    use_libevent      => false,
    daemonize         => true,
    s2s_secure_auth   => false,
    ssl_custom_config => false,
    log_sinks         => [],
    log_advanced      => {
      'error' => 'syslog',
    },
    custom_options    => {
      'proxy65_ports'     => 5282,
      'https_ssl'         => {
        'key'         => "/etc/prosody/certs/${prosody_fqdn}/privkey.pem",
        'certificate' => "/etc/prosody/certs/${prosody_fqdn}/fullchain.pem",
      },
      'https_certificate' => {
        '[5281]' => "/etc/prosody/certs/${prosody_fqdn}/privkey.pem",
      },
    },
    modules_base      => [ 'roster', 'saslauth', 'tls', 'dialback', 'disco',
      'posix', 'private', 'vcard', 'version', 'uptime', 'time', 'ping', 'pep',
    ],
    modules           => [
      'http_upload', 'carbons', 'csi',
      'throttle_presence', 'filter_chatstates',
      'smacks',  'blocking', 'cloud_notify',
      'http', 'mam', 'admin_telnet',
    ],

  }

  prosody::virtualhost {
    $prosody_domain:
      ensure         => present,
      ssl_key        => "/etc/prosody/certs/${prosody_fqdn}/privkey.pem",
      ssl_cert       => "/etc/prosody/certs/${prosody_fqdn}/fullchain.pem",
      ssl_copy       => false,
      components     => {
        $prosody_fqdn => {
          'type'    => 'proxy65',
          'options' => {
            'proxy65_address' => "'${prosody_fqdn}'",
            'proxy65_acl'     => "'${prosody_domain}'",
          }
        }
      },
      custom_options => {
        'http_upload_quota'           => 4096,
        'http_upload_expire_after'    => 14400,
        'http_upload_file_size_limit' => 2097152,
      }
  }

  file { '/etc/dehydrated/hooks/prosody.sh':
    ensure  => present,
    content => epp("${module_name}/service/prosody/prosody-hook.sh.epp",{
        'fqdn'   => $prosody_fqdn,
        'domain' => $prosody_domain,
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
  }

}
