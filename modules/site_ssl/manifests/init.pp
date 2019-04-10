# this class is a wrapper to deploy ssl certificates
#
# @param nullmailer_pem contains the ssl certificate/key used for nullmailer
#
class site_ssl (
  Variant[String, Undef] $nullmailer_pem = lookup('site_ssl::nullmailer::client', String, deep, undef)
) {

  if $nullmailer_pem {

    # the puppet module takes care of creating the directory
    file { '/etc/nullmailer/client.pem':
      ensure  => present,
      owner   => 'mail',
      group   => 'mail',
      mode    => '0440',
      content => $nullmailer_pem,
    }
  }
}
