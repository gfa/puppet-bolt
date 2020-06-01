# this class manages dovecot
#
# TODO: this class is way too big, split it
#
# @param users_file file where the users and their passwords are saved
# @param ssl_dh_file location of the dh file
# @param store_username user used to store all mail on disk, imap proc runs under this user
# @param store_group the group for the user above
# @param store_uid the uid for the user
# @param store_gid the gid for the user
# @param store_home the home for the user and root of the mail store
# @param ssl_hostname hostname under which the ssl certificates where issues
# @param sieve_bin_dir location where the binaries called by sieve scripts live
#

class profile::service::dovecot (
  Stdlib::UnixPath $users_file = '/etc/dovecot/users',
  Stdlib::UnixPath $ssl_dh_file = '/etc/dovecot-dh.pem',
  String $store_username = 'vmail',
  String $store_group = 'vmail',
  Integer $store_uid = 999,
  Integer $store_gid = 999,
  Stdlib::UnixPath $store_home = '/srv/vmail',
  Stdlib::Fqdn $ssl_hostname = $facts['networking']['fqdn'],
  Stdlib::UnixPath $sieve_bin_dir = '/usr/local/bin'
) {

  include profile::networking::firewall::service::dovecot
  include profile::networking::firewall::fail2ban::dovecot

  openssl::dhparam { $ssl_dh_file:
    size =>  2048,
  }

  file { $users_file:
    ensure => file,
  }

  class { 'dovecot':
    config  => {
      '!include_try' => '/usr/share/dovecot/protocols.d/*.protocol',
    },
    configs => {
      '10-auth'                    => {
        auth_mechanisms => 'plain login',
        passdb          => {
          driver => 'passwd-file',
          args   => "scheme=CRYPT username_format=%u ${users_file}",
        },
        userdb          => {
          driver         => 'passwd-file',
          args           => "username_format=%u ${users_file}",
          default_fields => "uid=${store_username} gid=${store_group} home=${store_home}/%d/%u mail_location=maildir:${store_home}/%d/%u/mail:INDEX=${store_home}/%d/%u/index:LAYOUT=fs",
        }
      },
      '10-logging'                 => {
        log_path => 'syslog',
        plugin   => {},
      },
      '10-master'                  => {
        'service imap-login'  => {
          'inet_listener imap'  => {
            port => 143,
          },
          'inet_listener imaps' => {
            port => 993,
            ssl  => 'yes',
          }
        },
        'service lmtp'        => {
          'unix_listener /var/spool/postfix/private/dovecot-lmtp' => {
            user  => 'postfix',
            group => 'postfix',
            mode  => '0600',
          }
        },
        'service imap'        => {
          vsz_limit => '$default_vsz_limit',
        },
        'service auth'        => {
          user                                            => '$default_internal_user',
          'unix_listener /var/spool/postfix/private/auth' => {
            mode => '0666',
          },
          'unix_listener auth-userdb'                     => {
            mode          => '0666',
          }
        },
        'service auth-worker' => {
          user => '$default_internal_user',
        },
        'service dict'        => {
          unix_listener => 'dict'
        }
      },
      '10-mail'                    => {
        mail_location            => "mbox:~/mail:INBOX=${store_home}/%u",
        mail_plugins             => 'acl zlib fts',
        mailbox_list_index       => 'yes',
        maildir_very_dirty_syncs => 'yes',
        'namespace inbox'        => {
          inbox => 'yes',
        }
      },
      '10-ssl'                     => {
        ssl               => 'required',
        ssl_cert          => "</var/lib/dehydrated/certs/${ssl_hostname}/fullchain.pem",
        ssl_key           => "</var/lib/dehydrated/certs/${ssl_hostname}/privkey.pem",
        ssl_client_ca_dir => '/etc/ssl/certs',
        ssl_dh            => "<${ssl_dh_file}",
      },
      '15-lda'                     => {
        lda_mailbox_autocreate    => 'yes',
        lda_mailbox_autosubscribe => 'yes',
        'protocol lda'            => {
          mail_plugins              => '$mail_plugins sieve acl',
        },
      },
      '15-mailboxes'               => {
        'namespace inbox' => {
          'mailbox Drafts'          => {
            special_use => '\Drafts',
            auto        => 'subscribe',
          },
          'mailbox Junk'            => {
            special_use => '\Junk',
            auto        => 'subscribe',
          },
          'mailbox Trash'           => {
            special_use => '\Sent',
            auto        => 'subscribe',
          },
          'mailbox Sent'            => {
            special_use => '\Sent',
            auto        => 'subscribe',
          },
          'mailbox "Sent Messages"' => {
            special_use => '\Drafts',
          }
        }
      },
      '20-imap'                    => {
        'protocol imap' => {
          mail_plugins => '$mail_plugins imap_acl acl imap_sieve zlib imap_zlib',
        }
      },
      '20-lmtp'                    => {
        lmtp_save_to_detail_mailbox => 'yes',
        'protocol lmtp'             => {
          mail_plugins => '$mail_plugins sieve zlib',
        }
      },
      '20-managesieve'             => {
        'service managesieve-login' => {
          'inet_listener sieve' => {
            port => 4190,
          }
        },
        'protocol sieve'            => {},
      },
      '90-acl'                     => {
        plugin => {
          acl             => "vfile:${store_home}global-acls:cache_secs=300",
          acl_shared_dict => "file:${store_home}/shared-mailboxes",
        }
      },
      '90-plugin'                  => {
        plugin => {
          fts_autoindex_exclude     => '\Junk',
          fts_autoindex_exclude2    => '\Trash',
          fts_autoindex             => 'yes',

          imapsieve_mailbox1_name   => 'Junk',
          imapsieve_mailbox1_causes => 'COPY',
          imapsieve_mailbox1_before => "file:${store_home}/report-spam.sieve",

          imapsieve_mailbox2_name   => '*',
          imapsieve_mailbox2_from   => 'Junk',
          imapsieve_mailbox2_causes => 'COPY',
          imapsieve_mailbox2_before => "file:${store_home}/report-ham.sieve",
        }
      },
      '90-sieve'                   => {
        plugin                    => {
          sieve                   => 'file:~/sieve;active=~/.dovecot.sieve',
          sieve_after             => "${store_home}/default.sieve",
          sieve_global_extensions => '+vnd.dovecot.pipe +vnd.dovecot.execute',
          sieve_plugins           => 'sieve_imapsieve sieve_extprograms',
        }
      },
      '90-sieve-sieve_extprograms' => {
        plugin => {
          sieve_pipe_bin_dir      => $sieve_bin_dir,
          sieve_filter_bin_dir    => $sieve_bin_dir,
          sieve_execute_bin_dir   => $sieve_bin_dir,
          sieve_global_extensions => '+vnd.dovecot.pipe +vnd.dovecot.execute',
        }
      }
    }
  }

  package { 'mblaze':
    ensure => present,
  }

  ['sa-learn-ham.sh', 'sa-learn-spam.sh', 'dovecot-zlib-cron-compressor.sh'].each |$sh_script| {
    file { "${sieve_bin_dir}/${sh_script}":
      ensure => file,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/${module_name}/service/dovecot/${sh_script}",
    }
  }

  ['default.sieve', 'report-ham.sieve', 'report-spam.sieve'].each |$sieve_script| {
    file { "${store_home}/${sieve_script}":
      ensure => file,
      mode   => '0644',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/${module_name}/service/dovecot/${sieve_script}",
    }
  }

  $cron_contents = "MAILTO=root \n16 20 * * * ${store_username} chronic bash ${sieve_bin_dir}/dovecot-zlib-cron-compressor.sh \n"

  file { '/etc/cron.d/mail-compress':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $cron_contents,
  }

}
