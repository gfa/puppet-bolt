# this class does the additional things that need to be done on an exit
#
# @param contact_email contact email
#

class site_tor::exit (
  String $contact_email,
) {

  file { '/etc/tor/how_tor_works_thumb.png':
    ensure  => present,
    source  => 'puppet:///modules/site_tor/how_tor_works_thumb.png',
    require => Package['tor'],
  }

  file { '/etc/tor/tor-exit-notice.html':
    ensure  => file,
    content => template('site_tor/tor-exit-notice.html.erb'),
    require => Package['tor'],
  }

}
