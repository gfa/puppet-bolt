# this configures logcheck
#
# @param content content of /etc/logcheck/logcheck.conf
#

class base::logcheck (
  String $content,
) {

  file { '/etc/logcheck/logcheck.conf':
    ensure  => present,
    content => $content,
    owner   => 'root',
    group   => 'logcheck',
    mode    => '0640',
    require => Package['logcheck'],
  }
}
