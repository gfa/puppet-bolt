# this class manages the local prosody install
#
# @param prosody_fqdn the fqdn behind the prosody server
# @param prosody_domain the domain this prosody server serves
#
# TODO: make this a define and support multiple domains
#

class site_prosody (
  Stdlib::Fqdn $prosody_fqdn,
  Stdlib::Fqdn $prosody_domain,
) {

  include site_dehydrated
  include site_munin::node

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

  ~> posix_acl { '/etc/prosody/prosody.cfg.lua':
    action     => exact,
    recursive  => false,
    provider   => posixacl,
    permission => [
      'user::rw',
      'group::r',
      'group:rssfeeds:rwx',
      'group:prosody:r',
      'mask::r',
      'other::',
    ],
  }

  ~> posix_acl { "/etc/prosody/conf.avail/${prosody_domain}.cfg.lua":
    action     => exact,
    recursive  => false,
    provider   => posixacl,
    permission => [
      'user::rw',
      'group::r',
      'group:rssfeeds:rwx',
      'group:prosody:r',
      'mask::r',
      'other::',
    ],
  }

  file { '/etc/dehydrated/hooks/prosody.sh':
    ensure  => present,
    content => epp("${module_name}/prosody-hook.sh.epp",{
        'fqdn'   => $prosody_fqdn,
        'domain' => $prosody_domain,
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
  }

  site_munin::node::conf { 'prosody':
    source => "puppet:///modules/${module_name}/prosody_munin.conf"
  }

  site_munin::node::check { 'ps_prosody':
    script => 'ps_'
  }

  $plugins_to_install = ['prosody_users', 'prosody_c2s']

  $plugins_to_install.each |$index, $plugin| {
    file { "/usr/share/munin/plugins/${plugin}":
      ensure => file,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/${module_name}/${plugin}"
    }

    site_munin::node::check { $plugin:
      script => $plugin
    }

  }

  $prosody_c2s_plugins = [ 'prosody_uptime', 'prosody_presence', 'prosody_s2s']

  $prosody_c2s_plugins.each |$index2, $plugin2| {
    site_munin::node::check { $plugin2:
      script => 'prosody_c2s'
    }
  }

}
