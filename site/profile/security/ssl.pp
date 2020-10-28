# this class is a wrapper to deploy ssl certificates
#
# @param nullmailer_pem contains the ssl certificate/key used for nullmailer
#
# TODO: make site_ssl:: hiera a hash with multiple certs
#
class profile::security::ssl (
  Variant[String, Type[Undef]] $nullmailer_pem = lookup({
      name          => 'site_ssl::nullmailer::client',
      merge         => 'deep',
      default_value => Undef,
  })
) {

  # the more simple if $var { never worked here
  if $nullmailer_pem != Undef {

    # the puppet module takes care of creating the directory
    file { '/etc/nullmailer/client.pem':
      owner   => 'mail',
      group   => 'mail',
      mode    => '0440',
      content => $nullmailer_pem,
    }
  }
}
