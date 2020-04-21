# this class manages the local prosody install
#
# @param prosody_fqdn the fqdn behind the prosody server
# @param prosody_domain the domain this prosody server serves
# @param prosody_admins the administrators of this server
#
# TODO: make this a define and support multiple domains
#

class profile::service::prosody (
  Stdlib::Fqdn $prosody_fqdn,
  Stdlib::Fqdn $prosody_domain,
  Array[String] $prosody_admins,
) {

  include profile::security::ssl::dehydrated
  include profile::monitoring::munin::node::plugin::prosody

  package { 'prosody-modules':
    ensure => present,
  }

  class { 'prosody':
    require           => File['/srv/prosody/compiled'],
    authentication    => 'internal_plain',
    use_libevent      => false,
    daemonize         => true,
    s2s_secure_auth   => false,
    ssl_custom_config => false,
    admins            => $prosody_admins,
    log_level         => 'warn',
    log_sinks         => [],
    log_advanced      => {
      'warn' => 'syslog',
    },
    custom_options    => {
      'reload_modules'    => [ 'groups', 'firewall' ],
      'proxy65_ports'     => 5282,
      'firewall_scripts'  => '/srv/prosody/compiled/spammer.pfw',
      'https_ssl'         => {
        'key'         => "/etc/prosody/certs/${prosody_fqdn}/privkey.pem",
        'certificate' => "/etc/prosody/certs/${prosody_fqdn}/fullchain.pem",
      },
      'https_certificate' => {
        '[5281]' => "/etc/prosody/certs/${prosody_fqdn}/privkey.pem",
      },
      'contact_info'      => {
        abuse    => ["mailto:abuse@${prosody_domain}"],
      }
    },
    modules_base      => [ 'roster', 'saslauth', 'tls', 'dialback', 'disco',
      'posix', 'private', 'vcard', 'version', 'uptime', 'time', 'ping', 'pep',
    ],
    modules           => [
      'http_upload', 'carbons', 'csi',
      'throttle_presence', 'filter_chatstates',
      'smacks',  'blocking', 'cloud_notify',
      'http', 'mam', 'admin_telnet', 'firewall',
      'server_contact_info',
    ],

  }

  prosody::virtualhost {
    $prosody_domain:
      ensure         => present,
      ssl_key        => "/etc/prosody/certs/${prosody_fqdn}/privkey.pem",
      ssl_cert       => "/etc/prosody/certs/${prosody_fqdn}/fullchain.pem",
      ssl_copy       => false,
      components     => {
        $prosody_fqdn       => {
          'type'    => 'proxy65',
          'options' => {
            'proxy65_address' => "'${prosody_fqdn}'",
            'proxy65_acl'     => "'${prosody_domain}'",
          }
        },
        "${prosody_domain}" => {
          'type' => 'http_upload'
        }
      },
      custom_options => {
        'http_upload_quota'           => 100*1024*1024,  # 100M
        'http_upload_expire_after'    => 60*60*24*30,  # 30 days
        'http_upload_file_size_limit' => 16*1024*1024,  # 16M
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

  file { '/srv/prosody':
    ensure => directory,
    mode   => '0750',
    owner  => 'root',
    group  => 'prosody',
  }

  file { '/srv/prosody/compiled':
    ensure => directory,
    mode   => '0750',
    owner  => 'root',
    group  => 'prosody',
  }

}
