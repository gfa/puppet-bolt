# This class enables the puppet agent
#

class base::enable_puppet {

  service { 'puppet':
    ensure => stopped,
    enable => false,
  }

  service { 'mcollective':
    ensure => stopped,
    enable => false,
  }

  package { 'puppet-release':
    ensure => purged,
  }

  package { 'puppet5-release':
    ensure => purged,
  }

  package { 'puppet6-release':
    ensure => purged,
  }

  package { 'puppet-agent':
    ensure => purged,
  }

  package { 'puppetlabs-release-pc1':
    ensure => purged,
  }

  package { 'puppetlabs-release':
    ensure => purged,
  }

  $content = "2 */2 * * * root chronic puppet agent --verbose --onetime --no-daemonize --show_diff\n"

  file { '/etc/cron.d/puppet-agent':
    ensure  => file,
    content => $content,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

}
