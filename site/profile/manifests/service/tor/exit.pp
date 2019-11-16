# this class configures a tor exit
#
# @param contact_email contact email
#

class profile::service::tor::exit (
  String $contact_email,
) {

  include tor

  file { '/etc/tor/how_tor_works_thumb.png':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/service/tor/how_tor_works_thumb.png",
    require => Package['tor'],
  }

  file { '/etc/tor/tor-exit-notice.html':
    ensure  => file,
    content => template("${module_name}/service/tor/tor-exit-notice.html.erb"),
    require => Package['tor'],
  }

}
